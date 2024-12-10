from flask import Flask, jsonify, request
import logging
import os

# Initialize Flask app
app = Flask(__name__)

#debug mode enabled
DEBUG_MODE = os.getenv("DEBUG_MODE", "false").lower() == "true"

# Set up logging
log_level = logging.DEBUG if DEBUG_MODE else logging.INFO
logging.basicConfig(
    level=log_level,  # Set log level based on debug mode
    format="%(asctime)s - %(levelname)s - %(message)s",
)

@app.route('/student', methods=['GET'])
def student_status():
    """
    Handles GET requests to the /student endpoint.
    Returns a JSON response indicating student status.
    """
    try:
        app.logger.info("Received request at /student endpoint")
        response = {"student_status": "hired"}
        return jsonify(response), 200
    except Exception as e:
        app.logger.error(f"Error processing request: {e}")
        response = {"error": "Internal Server Error"}
        return jsonify(response), 500


@app.errorhandler(404)
def handle_not_found(error):
    """
    Handles 404 errors when a requested endpoint is not found.
    """
    app.logger.warning(f"404 error - Path: {request.path}")
    return jsonify({"error": "Endpoint not found"}), 404


@app.errorhandler(405)
def handle_method_not_allowed(error):
    """
    Handles 405 errors when an unsupported HTTP method is used.
    """
    app.logger.warning(
        f"405 error - Method {request.method} not allowed on {request.path}"
    )
    return jsonify({"error": "Method not allowed"}), 405


if __name__ == '__main__':
    app.logger.info(f"Starting the microservice in {'DEBUG' if DEBUG_MODE else 'PRODUCTION'} mode")
    app.run(host='0.0.0.0', port=8080, debug=DEBUG_MODE)
