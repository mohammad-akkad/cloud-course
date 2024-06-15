# Start from the official Golang image as the build stage
FROM golang:1.22-alpine AS builder

# Set the Current Working Directory inside the container
WORKDIR /app

# Copy go mod and sum files
COPY go.mod go.sum ./

# Download all dependencies. Dependencies will be cached if the go.mod and go.sum files are not changed
RUN go mod tidy

# Copy the source code from the current directory to the Working Directory inside the container
COPY . .

# Build the Go app
RUN go build -o main .

# Start a new stage from scratch
FROM alpine:latest

# Set the Current Working Directory inside the container
WORKDIR /root/

# Copy the Pre-built binary file from the previous stage
COPY --from=builder /app/main .

# Copy the views folder if necessary
COPY --from=builder /app/views ./views

# Copy the CSS files if necessary
COPY --from=builder /app/css ./css

# Set environment variables
ENV DATABASE_URI mongodb://mongodb:27017

# Expose port 3030 to the outside world
EXPOSE 3030

# Command to run the executable
CMD ["./main"]
