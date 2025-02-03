from flask import Flask, jsonify, render_template
import logging

# Create the Flask application instance
app = Flask(__name__)

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

@app.route('/')
def home():
    """Simple web page."""
    return "<h1>Welcome to the Flask App!!</h1><p>Health check available at /health</p>"

@app.route('/health', methods=['GET'])
def health_check():
    """Health check endpoint."""
    logger.info("Health check accessed")
    return jsonify(status="healthy"), 200

if __name__ == '__main__':
    # Run the app on port 8080 and listen on all network interfaces
    app.run(host='0.0.0.0', port=80, debug=False)
