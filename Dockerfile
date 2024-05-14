# Start from the official Golang image
FROM golang:1.16-alpine AS build

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod tidy

# Copy the source code from the current directory to the Working Directory inside the container
COPY . .

# Command to run the Go application
CMD ["go", "run", "."]
