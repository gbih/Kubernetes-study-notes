# 17.3.2 Preventing broken connections during pod shut-down

### Notes

- Cannot use scratch-based image here, since it lacks a shell and we cannot run `sh`, etc
