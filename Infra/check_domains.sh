while read -r domain; do
    echo -n "$domain: "
    response=$(curl -sI "$domain" | awk '/^HTTP/ {print $2}')
    echo $response
done < "/Users/omartulashvili/Documents/2-Areas/Bash/Infra/domains.txt"