# Generate RSA private key (e.g., 2048-bit)
openssl genrsa -out ./localhost.key 2048

# Generate a Certificate Signing Request (CSR)
openssl req -new -key ./localhost.key -out ./localhost.csr

# Generate a self-signed certificate (valid for 1 year)
openssl x509 -req -days 365 -in ./localhost.csr -signkey ./localhost.key -out ./localhost.crt
