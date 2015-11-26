# Requirements


# Environmental
The following environmental variables must be populated, when running container 

- DEPOT_USER,
- DEPOT_PASSWORD

# Ports
The following ports must be mapped, when running container 

 - 943 #https webui listen 
 - 60000 #tcp listen
 - 60001 #udp listen
 
# Volumes
The following volumes must be mapped, when running container 

- /srv/couchpotato/config
- /srv/couchpotato/data
- /mnt/movies
- /mnt/downloads/[Movies]:/mnt/downloads
- /mnt/blackhole/[Movies]:/mnt/blackhole
