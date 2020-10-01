# MULTISTAGE BUILD
# Step 1: Build executable binary
# Base image
FROM golang:1.15.2-alpine AS build

WORKDIR /src/

# Copy Go code from current dir
COPY main.go go.* /src/

# Tell Docker how to build Go binary
# CGO_ENABLED=0: provide statically linked binary
RUN CGO_ENABLED=0 go build -o /bin/app

# Step 2: Build a small image using scratch
# Use empty container image
FROM scratch

# Copy the static executable
COPY --from=build /bin/app /bin/app

# Run the binary
ENTRYPOINT ["/bin/app"]



