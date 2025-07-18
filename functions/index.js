const express = require('express');
const cors = require('cors');
const axios = require('axios');

const app = express();
app.use(cors());

app.get('/scan/:batchId', async (req, res) => {
  const batchId = req.params.batchId;
  const ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;

  try {
    const ipinfoToken = "cca06902c3e3c7"; // 🔴 Replace this
    const response = await axios.get(`https://ipinfo.io/${ip}?token=${ipinfoToken}`);
    const data = response.data;

    console.log(`Scan detected for batch ID: ${batchId}`);
    console.log(`IP Address: ${ip}`);
    console.log(`Location: ${data.city}, ${data.region}, ${data.country}`);
    console.log(`Coordinates: ${data.loc}`);

    // Later: Save to Firestore or log somewhere

    res.send(`Scan logged for batch ${batchId}`);
  } catch (err) {
    console.error("Error fetching IP info:", err);
    res.status(500).send("Error logging scan.");
  }
});

app.listen(3000, () => {
  console.log("Scan logger running on port 3000");
});
