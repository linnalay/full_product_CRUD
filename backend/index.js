const express = require('express');
const cors = require('cors');
const { sql, poolPromise } = require('./db');
require('dotenv').config();

const app = express();
app.use(cors());
app.use(express.json());

const PORT = 5000;

// GET all products
app.get('/products', async (req, res) => {
  try {
    const pool = await poolPromise;
    const result = await pool.request().query('SELECT * FROM PRODUCTS');
    res.json(result.recordset);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// GET product by ID
app.get('/products/', async (req, res) => {
  const { id } = req.query;
  if (!id) return res.status(400).json({ error: 'ID required' });

  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input('id', sql.Int, id)
      .query('SELECT * FROM PRODUCTS WHERE PRODUCTID = @id');
    if (result.recordset.length === 0) return res.status(404).json({ error: 'Not found' });
    res.json(result.recordset[0]);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// POST create product
app.post('/products', async (req, res) => {
  const { productname, price, stock } = req.body;
  if (!productname || price <= 0 || stock < 0) {
    return res.status(400).json({ error: 'Invalid input' });
  }

  try {
    const pool = await poolPromise;
    await pool
      .request()
      .input('productname', sql.NVarChar(100), productname)
      .input('price', sql.Decimal(10, 2), price)
      .input('stock', sql.Int, stock)
      .query('INSERT INTO PRODUCTS (PRODUCTNAME, PRICE, STOCK) VALUES (@productname, @price, @stock)');
    res.status(201).json({ message: 'Product created' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// PUT update product
app.put('/products', async (req, res) => {
  const { id } = req.query;
  const { productname, price, stock } = req.body;
  if (!id || !productname || price <= 0 || stock < 0) {
    return res.status(400).json({ error: 'Invalid input' });
  }

  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input('id', sql.Int, id)
      .input('productname', sql.NVarChar(100), productname)
      .input('price', sql.Decimal(10, 2), price)
      .input('stock', sql.Int, stock)
      .query('UPDATE PRODUCTS SET PRODUCTNAME=@productname, PRICE=@price, STOCK=@stock WHERE PRODUCTID=@id');
    if (result.rowsAffected[0] === 0) return res.status(404).json({ error: 'Not found' });
    res.json({ message: 'Product updated' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// DELETE product
app.delete('/products', async (req, res) => {
  const { id } = req.query;
  if (!id) return res.status(400).json({ error: 'ID required' });

  try {
    const pool = await poolPromise;
    const result = await pool
      .request()
      .input('id', sql.Int, id)
      .query('DELETE FROM PRODUCTS WHERE PRODUCTID=@id');
    if (result.rowsAffected[0] === 0) return res.status(404).json({ error: 'Not found' });
    res.json({ message: 'Product deleted' });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Start the server
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
  console.log(`Open API: http://localhost:${PORT}/products`);
});
