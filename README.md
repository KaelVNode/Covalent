# Covalent

# Fixs Error Logs websocket


# Hapus Instalan lama
```
docker stop light-client && docker rm light-client
```

```
docker system prune -a
```


```
rm -rf  ewm-das
```
install IPFS
```
wget https://dist.ipfs.tech/kubo/v0.30.0/kubo_v0.30.0_linux-amd64.tar.gz && tar -xvzf kubo_v0.30.0_linux-amd64.tar.gz && sudo bash kubo/install.sh
```

# install
```
git clone https://github.com/covalenthq/ewm-das
```

```
cd ewm-das
```

```
nano Dockerfile.lc .
```
# Cari bagian 
```

# Checkout the specific version v0.29.0 ganti
RUN git checkout v0.29.0
```
# ganti
```
# Checkout the specific version v0.30.0 ganti
RUN git checkout v0.30.0
```
# Save , CTRL + X +Y

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
