from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    anthropic_api_key: str
    supabase_url: str
    supabase_service_role_key: str
    ocr_confidence_threshold: float = 0.85

    class Config:
        env_file = ".env"


settings = Settings()
