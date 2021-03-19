FROM golang:1.14-alpine as builder

RUN apk add --update make curl glide git ca-certificates

WORKDIR /go/src/github.com/aist-science/hostpath-provisioner
COPY . .
RUN make

FROM scratch
COPY --from=builder /go/src/github.com/aist-science/hostpath-provisioner/hostpath-provisioner /
CMD ["/hostpath-provisioner"]