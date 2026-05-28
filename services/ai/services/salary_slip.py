import base64
import json
import anthropic
from models.salary_slip import SalarySlipExtraction
from config import settings

_client = anthropic.Anthropic(api_key=settings.anthropic_api_key)

SYSTEM_PROMPT = (
    "You are an expert at extracting structured data from Indian salary slips. "
    "Return ONLY valid JSON matching the schema. Set confidence (0.0-1.0) based on legibility. "
    "Use null for any field you cannot read reliably."
)

SCHEMA = """{
  "employer_name": "string | null",
  "employee_name": "string | null",
  "month": "string | null (e.g. 'March')",
  "year": "integer | null",
  "gross_salary": "float | null",
  "net_salary": "float | null",
  "bank_account_last4": "string | null",
  "confidence": "float 0.0-1.0"
}"""


async def extract_salary_slip(
    content: bytes, content_type: str
) -> SalarySlipExtraction:
    b64 = base64.standard_b64encode(content).decode()
    media = "image/jpeg" if "jpeg" in content_type else "image/png"

    message = _client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=1024,
        system=SYSTEM_PROMPT,
        messages=[
            {
                "role": "user",
                "content": [
                    {
                        "type": "image",
                        "source": {"type": "base64", "media_type": media, "data": b64},
                    },
                    {"type": "text", "text": f"Extract data per this schema:\n{SCHEMA}"},
                ],
            }
        ],
    )

    raw = message.content[0].text
    data = json.loads(raw)
    needs_review = data.get("confidence", 0) < settings.ocr_confidence_threshold

    return SalarySlipExtraction(**data, needs_review=needs_review, raw_response=raw)
