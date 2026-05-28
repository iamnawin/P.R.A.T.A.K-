import type { Result } from "@/types";

export interface SalarySlipData {
  employer_name: string | null;
  employee_name: string | null;
  month: string | null;
  year: number | null;
  gross_salary: number | null;
  net_salary: number | null;
  bank_account_last4: string | null;
  confidence: number;
  needs_review: boolean;
}

export async function extractSalarySlip(
  file: File
): Promise<Result<SalarySlipData>> {
  const form = new FormData();
  form.append("file", file);

  const res = await fetch(
    `${process.env.AI_SERVICE_URL}/ocr/salary-slip`,
    {
      method: "POST",
      headers: { "x-api-key": process.env.AI_SERVICE_API_KEY ?? "" },
      body: form,
    }
  );

  if (!res.ok) {
    return { success: false, error: `AI service error: ${res.status}` };
  }

  const data = (await res.json()) as SalarySlipData;
  return { success: true, data };
}
