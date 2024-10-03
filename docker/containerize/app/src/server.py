from flask import Flask, request, make_response

app = Flask(__name__)
app.config["DEBUG"] = True  # Enable debug mode


@app.route("/")
def index():
    content = "It's easier now to ask forgiveness than it is to get permission."
    fwd_for = "X-Forwarded-For: {}".format(request.headers.get("X-Forwarded-For", None))
    real_ip = "X-Real-IP: {}".format(request.headers.get("X-Real-IP", None))
    fwd_proto = "X-Forwarded-Proto: {}".format(
        request.headers.get("X-Forwarded-Proto", None)
    )

    output = "\n".join([content, fwd_for, real_ip, fwd_proto])
    response = make_response(output, 200)
    response.headers["Content-Type"] = "text/plain"

    return response
