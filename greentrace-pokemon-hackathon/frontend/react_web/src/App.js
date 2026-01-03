import React, { useEffect, useRef, useState } from 'react';
import mapboxgl from 'mapbox-gl';

const API_BASE_URL = process.env.API_BASE_URL || 'http://localhost:4000';
const MAPBOX_TOKEN = process.env.NEXT_PUBLIC_MAPBOX_TOKEN;

const tasks = [
  {
    title: 'Recycle a bottle',
    points: 80,
    description: 'Recyclable waste brings the biggest eco-reward.'
  },
  {
    title: 'General waste patrol',
    points: 50,
    description: 'Dispose general waste to protect the city.'
  }
];

function App() {
  const mapContainer = useRef(null);
  const [status, setStatus] = useState('Find a Trash-Monster and check in!');
  const [points, setPoints] = useState(0);

  useEffect(() => {
    if (!mapContainer.current) return;

    mapboxgl.accessToken = MAPBOX_TOKEN;
    const map = new mapboxgl.Map({
      container: mapContainer.current,
      style: 'mapbox://styles/mapbox/streets-v12',
      center: [114.17, 22.32],
      zoom: 12
    });

    map.addControl(new mapboxgl.NavigationControl(), 'top-right');

    fetch(`${API_BASE_URL}/api/bins`)
      .then((response) => response.json())
      .then((data) => {
        (data.bins || []).forEach((bin) => {
          const el = document.createElement('div');
          el.className = `monster-marker ${bin.type}`;
          const marker = new mapboxgl.Marker(el)
            .setLngLat([bin.lng, bin.lat])
            .setPopup(new mapboxgl.Popup().setHTML(`<strong>${bin.name}</strong><br/>${bin.type}`))
            .addTo(map);
          return marker;
        });
      })
      .catch(() => setStatus('Failed to load markers. Try again later.'));

    return () => map.remove();
  }, []);

  const handleCheckIn = async () => {
    try {
      setStatus('Checking in for eco coins...');
      const response = await fetch(`${API_BASE_URL}/api/checkin`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ userId: 'demo-user' })
      });
      const data = await response.json();
      setPoints(data.points || 0);
      setStatus(data.message || 'Check-in complete!');
    } catch (error) {
      setStatus('Check-in failed. Please try again.');
    }
  };

  return (
    <div className="app-shell">
      <header className="app-header">
        <h1>GreenTrace Web</h1>
        <div className="points">Pokemon Coins: {points}</div>
      </header>

      <div className="map-area">
        <div ref={mapContainer} className="map-container" />
        <div className="status-card">
          <span role="img" aria-label="leaf">🍃</span>
          <p>{status}</p>
        </div>
        <button className="floating-button" onClick={handleCheckIn}>
          Catch Coin
        </button>
      </div>

      <section className="task-list">
        <h2>Eco Tasks</h2>
        <div className="task-grid">
          {tasks.map((task) => (
            <div key={task.title} className="task-card">
              <h3>{task.title}</h3>
              <p>{task.description}</p>
              <div className="task-points">+{task.points} pts</div>
            </div>
          ))}
        </div>
      </section>
    </div>
  );
}

export default App;
