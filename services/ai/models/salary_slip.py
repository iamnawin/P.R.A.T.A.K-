from pydantic import BaseModel


class SalarySlipExtraction(BaseModel):
    employer_name: str | None
    employee_name: str | None
    month: str | None
    year: int | None
    gross_salary: float | None
    net_salary: float | None
    bank_account_last4: str | None
    confidence: float
    needs_review: bool
    raw_response: str
