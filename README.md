## Docker Optimization

### Docker History Layer Structure
```text
IMAGE          CREATED          CREATED BY                                      SIZE
<IMAGE_ID>     1 min ago        COPY . .                                        1.2MB
<IMAGE_ID>     2 mins ago       RUN pip install --no-cache-dir -r requiremen…   45MB
<IMAGE_ID>     3 mins ago       COPY requirements.txt .                         1.5kB
