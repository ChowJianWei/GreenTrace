import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import { createClient } from 'supabase-js';

dotenv.config();

const app = express();
const port = process.env.PORT || 4000;

app.use(cors());
app.use(express.json({ limit: '10mb' }));

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey =
  process.env.NEXT_PUBLIC_SUPABASE_SERVICE_KEY ||
  process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY ||
  process.env.SUPABASE_SERVICE_KEY;

const supabase = supabaseUrl && supabaseKey ? createClient(supabaseUrl, supabaseKey) : null;

const userPoints = new Map();

const defaultBins = [
  { id: 1, name: 'Central Eco Bin', type: 'recycle', lat: 22.2819, lng: 114.1589 },
  { id: 2, name: 'Kowloon Clean Spot', type: 'general', lat: 22.3193, lng: 114.1694 },
  { id: 3, name: 'Harbor Toilet Monster', type: 'toilet', lat: 22.308, lng: 114.1717 }
];

app.get('/api/bins', async (_req, res) => {
  try {
    if (!supabase) {
      return res.json({ bins: defaultBins });
    }

    const { data, error } = await supabase.from('bins').select('*');
    if (error) {
      return res.json({ bins: defaultBins });
    }

    return res.json({ bins: data || defaultBins });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to load bins.' });
  }
});

app.post('/api/classify', async (req, res) => {
  try {
    const { imageBase64 } = req.body;
    if (!imageBase64) {
      return res.status(400).json({ error: 'Image is required.' });
    }

    const isRecyclable = imageBase64.length % 2 === 0;
    const category = isRecyclable ? 'recyclable' : 'general';
    const points = isRecyclable ? 80 : 50;

    return res.json({ category, points, message: 'Classification complete.' });
  } catch (error) {
    return res.status(500).json({ error: 'Classification failed.' });
  }
});

app.post('/api/checkin', (req, res) => {
  try {
    const { userId } = req.body;
    if (!userId) {
      return res.status(400).json({ error: 'userId is required.' });
    }

    const current = userPoints.get(userId) || 0;
    const updated = current + 20;
    userPoints.set(userId, updated);

    return res.json({
      points: updated,
      message: 'Check-in successful! You earned a Pokemon Coin.'
    });
  } catch (error) {
    return res.status(500).json({ error: 'Check-in failed.' });
  }
});

app.get('/api/points/:userId', (req, res) => {
  try {
    const { userId } = req.params;
    const points = userPoints.get(userId) || 0;
    return res.json({ userId, points });
  } catch (error) {
    return res.status(500).json({ error: 'Failed to load points.' });
  }
});

app.listen(port, () => {
  console.log(`GreenTrace backend running on port ${port}`);
});
