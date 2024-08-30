import requests
import time

# # Ваши данные для авторизации
# api_key = "V3E9V9V8E9C9A7V6X3U0"
# password = "b00hWGCdZC"

# ## kislovmb
# api_key = "Q5X8A9W0V3M9V4O4"
# password = "khsMf34LP5b%"
# URL для получения списка доменов

domains_list_url = f"https://api.internet.bs/Domain/List?apiKey={api_key}&password={password}"


# Функция для получения NS-записей для домена
def get_ns_records(domain):
    domain_info_url = f"https://api.internet.bs/Domain/Info?ApiKey={api_key}&Password={password}&Domain={domain}"
    response = requests.get(domain_info_url)
    ns_records = {}
    for line in response.text.splitlines():
        if line.startswith("nameserver_0="):
            ns_records['nameserver_0'] = line.split('=')[1]
        elif line.startswith("nameserver_1="):
            ns_records['nameserver_1'] = line.split('=')[1]
    return ns_records


# Старт дебаг информации
start_time = time.time()
print("Получаем список доменов...")

# Отправляем запрос к API для получения списка доменов
response = requests.get(domains_list_url)
data = response.text

# Парсинг ответа, чтобы получить домены
domains = []
for line in data.splitlines():
    if line.startswith("domain_"):
        domains.append(line.split('=')[1])

print(f"Найдено доменов: {len(domains)}")
print(f"Время на получение списка доменов: {time.time() - start_time:.2f} секунд")

# Список доменов с нужными NS-записями
filtered_domains = []

# Проверка каждого домена и фильтрация
for i, domain in enumerate(domains):
    domain_start_time = time.time()
    print(f"Проверка домена {i + 1}/{len(domains)}: {domain}...")
    ns_records = get_ns_records(domain)

    if ns_records.get('nameserver_0') == 'garret.ns.cloudflare.com' and ns_records.get(
            'nameserver_1') == 'mallory.ns.cloudflare.com':
        filtered_domains.append(domain)

    print(f"Время на проверку домена {domain}: {time.time() - domain_start_time:.2f} секунд")

# Выводим отфильтрованные домены
print("\nДомены с nameserver_0=garret.ns.cloudflare.com и nameserver_1=mallory.ns.cloudflare.com:")
for domain in filtered_domains:
    print(domain)

print(f"\nОбщее время выполнения: {time.time() - start_time:.2f} секунд")