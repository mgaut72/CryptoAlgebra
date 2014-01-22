sudo docker run -i -cidfile="./cid.txt" -t -p 4000:4000 -v ~/documents/semester6/cryptography/CryptoAlgebra:/data ghp2 "$@"
sudo docker stop $(cat ./cid.txt)
sudo docker rm $(cat ./cid.txt)
sudo rm ./cid.txt
