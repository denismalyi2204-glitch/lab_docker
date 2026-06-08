FROM python:3.9-slim

WORKDIR /app

# Копируем только requirements.txt из папки app/
COPY app/requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

# Копируем весь код приложения
COPY app/ .

# Открываем порт, который использует приложение (Flask по умолчанию 5000)
EXPOSE 5000

CMD ["python", "app.py"]
