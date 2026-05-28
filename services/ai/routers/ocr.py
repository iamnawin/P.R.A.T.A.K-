from fastapi import APIRouter, UploadFile, File, HTTPException
from services.salary_slip import extract_salary_slip
from models.salary_slip import SalarySlipExtraction

router = APIRouter()


@router.post("/salary-slip", response_model=SalarySlipExtraction)
async def ocr_salary_slip(file: UploadFile = File(...)) -> SalarySlipExtraction:
    if file.content_type not in ("image/jpeg", "image/png", "application/pdf"):
        raise HTTPException(status_code=400, detail="Unsupported file type")
    content = await file.read()
    return await extract_salary_slip(content, file.content_type)
