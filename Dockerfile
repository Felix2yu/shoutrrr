FROM golang:1.25 AS build

ARG TARGETOS
ARG TARGETARCH

WORKDIR /src
COPY . .
RUN CGO_ENABLED=0 GOOS=$TARGETOS GOARCH=$TARGETARCH go build -o /out/shoutrrr ./shoutrrr

FROM alpine:3.23.4 as alpine

RUN apk add --no-cache ca-certificates

FROM scratch

COPY --from=alpine \
    /etc/ssl/certs/ca-certificates.crt \
    /etc/ssl/certs/ca-certificates.crt
COPY --from=build /out/shoutrrr /shoutrrr

ENTRYPOINT ["/shoutrrr"]
