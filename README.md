# Instructions 

- `docker build -t inspi4 -t inspi4:latest .`
- `docker run -it --rm -e 'DEFAULT_BLOCK_HOST_MASK="nothing"' -net host inspi4`

# Optional 

- create a custom `links.conf`
- `docker run -it --rm -e 'DEFAULT_BLOCK_HOST_MASK="nothing"' -net host -v $(pwd)/links.conf:/etc/inspircd/links.conf:ro inspi4`
