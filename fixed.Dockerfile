FROM python:3.13-slim AS builder

ENV AIOHTTP_NO_EXTENSIONS=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /build
RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

COPY . .
RUN pip install --upgrade pip setuptools wheel && \
    pip install .

FROM python:3.13-slim

ENV PATH="/opt/venv/bin:$PATH" \
    AIOHTTP_NO_EXTENSIONS=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

RUN groupadd --system aiohttp && useradd --system --gid aiohttp aiohttp
COPY --from=builder /opt/venv /opt/venv

USER aiohttp
CMD ["python", "-c", "import aiohttp; print(f'aiohttp {aiohttp.__version__} ready')"]
