# Covalent
# Otomastis
```
curl -O https://raw.githubusercontent.com/KaelVNode/Covalent/refs/heads/main/install_light_client.sh
```
```
chmod +x install_light_client.sh
```
```
./install_light_client.sh
```

# Manual
```
docker stop light-client && docker rm light-client
```

```
docker system prune -a
```


```
rm -rf  ewm-das
```

# install
```
git clone https://github.com/covalenthq/ewm-das
```

```
cd ewm-das
```
```
docker build -t covalent/light-client -f Dockerfile.lc .
```
```
docker run -d --restart always --name light-client -e PRIVATE_KEY="GANTI_PRIVATE_KEY_BURNER" covalent/light-client
```
# cek logs
```
docker logs -f light-client
```
