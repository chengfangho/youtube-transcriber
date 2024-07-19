import "./App.css";
import { useState } from "react";

const invoke_url = "https://your-api-endpoint.com/";

function App() {
  const [youtubeUrl, setYoutubeUrl] = useState("");
  const [transcriptionResult, setTranscriptionResult] = useState("");
  const [isLoading, setIsLoading] = useState(false);
  const [isError, setIsError] = useState(false);

  function sendUrl(e) {
    e.preventDefault();
    setIsLoading(true);
    setTranscriptionResult(""); // Clear previous result
    fetch(`${invoke_url}transcribe`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify({ url: youtubeUrl }),
    })
      .then(async (response) => {
        if (!response.ok) {
          throw new Error("Failed to fetch transcription");
        }
        const data = await response.json();
        setTranscriptionResult(data.transcription);
        setIsError(false);
        setIsLoading(false);
      })
      .catch((error) => {
        setTranscriptionResult(
          "Sorry, something went wrong. Please try again."
        );
        setIsError(true);
        setIsLoading(false);
        console.error(error);
      });
  }

  return (
    <div className="App">
      <h2>YouTube Transcriber</h2>
      <form onSubmit={sendUrl}>
        <input
          type="text"
          name="youtubeUrl"
          placeholder="Enter YouTube URL"
          value={youtubeUrl}
          onChange={(e) => setYoutubeUrl(e.target.value)}
        />
        <button type="submit">Transcribe</button>
      </form>
      {isLoading && <div className="loading">Loading...</div>}
      {transcriptionResult && (
        <div className={`result ${isError ? "error" : "success"}`}>
          {transcriptionResult}
        </div>
      )}
    </div>
  );
}

export default App;
