# Dont Edit
# [Nero Team](https://t.me/NeroTeam)
# Install 

```bash
sudo apt-get install lua5.2 liblua5.2-dev
git clone https://github.com/keplerproject/luarocks.git
cd luarocks
./configure
make build && make install
sudo luarocks install luasocket
sudo luarocks install luasec
sudo luarocks install redis-lua
sudo luarocks install fakeredis
sudo luarocks install serpent
cd ..
git clone https://github.com/NeroTeam/dontedit.git
# set token and admin id in botbase.lua
cd dontedit
sudo chmod 777 ./launch.sh
./launch.sh
```
# Thanks To Behrad