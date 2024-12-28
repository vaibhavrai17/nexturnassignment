/* Graded Assessment: Working with JSON Data
Problem:
You are tasked with implementing a product management system. The system will use JSON data for storing information about products. Each product has the following properties:
· id: Unique identifier for the product.
· name: Name of the product.
· category: Category of the product.
· price: Price of the product.
· available: Boolean indicating if the product is in stock.
The tasks below involve reading JSON data, adding new products, updating product information, and filtering products based on certain conditions.

Tasks:
1. Parse the JSON data:
Write a function that reads the JSON data (in the format above) and converts it into a usable data structure. You will need to parse the JSON into a JavaScript object.

2. Add a new product:
Write a function to add a new product to the catalog. This product will have the same structure as the others and should be appended to the products array.

3. Update the price of a product:
Write a function that takes a product ID and a new price and updates the price of the product with the given ID. If the product doesn’t exist, the function should return an error message.

4. Filter products based on availability:
Write a function that returns only the products that are available (i.e., available: true).

5. Filter products by category:
Write a function that takes a category name (e.g., "Electronics") and returns all products in that category. */





const productsData=`[{"id":101, "name":"Smartphone", "category":"Electronics", "price":500, "available":true},
{"id":102, "name":"Sofa", "category":"Furniture", "price":344, "available":true},
{"id":103, "name":"Washing Machine", "category":"Home Appliance", "price":895.34, "available":false}]`;

// Parse JSON data into JavaScript object
function parseProductsData(data) {
try {
const parsedData = JSON.parse(data);
console.log("Products data parsed successfully.");
return parsedData;
} catch (error) {
console.error("Invalid JSON data:", error);
return [];  // Return an empty array if parsing fails
}
}

// Add a new product to the catalog
function addProduct(catalog, newProduct) {
// Check if the new product has all required fields
const requiredFields = ["id", "name", "category", "price", "available"];
for (const field of requiredFields) {
if (!newProduct.hasOwnProperty(field)) {
console.error(Product is missing required field: ${field});
return;
}
}

// Check for unique ID
if (catalog.some(product => product.id === newProduct.id)) {
console.error("Product with this ID already exists");
return;
}

// Add product to the catalog
catalog.push(newProduct);
console.log("Product added successfully:", newProduct);
}

// Update the price of a product by ID
function updateProductPrice(catalog, productId, newPrice) {
const product = catalog.find(item => item.id === productId);
if (!product) {
console.error("Product not found.");
return;
}

// Ensure newPrice is a valid number
if (typeof newPrice !== "number" || newPrice < 0) {
console.error("Invalid price. Price must be a non-negative number.");
return;
}

product.price = newPrice;
console.log(Product price updated. ID: ${productId}, New Price: ${newPrice});
}

// Filter products based on availability
function filterAvailableProducts(catalog) {
const availableProducts = catalog.filter(product => product.available === true);
console.log("Available Products:", availableProducts);
return availableProducts;
}

// Filter products by category
function filterProductsByCategory(catalog, category) {
if (typeof category !== "string" || category.trim() === "") {
console.error("Invalid category. Please provide a valid category name.");
return [];
}
const filteredProducts = catalog.filter(product => product.category === category);
console.log(Products in category ${category} :, filteredProducts);
return filteredProducts;
}

const catalog = parseProductsData(productsData);

// Add a new product
addProduct(catalog, { id: 107, name: "Microwave", category: "Home Appliances", price: 250, available: true });
addProduct(catalog, { id: 117, name: "Mouse", category: "Electronics", available: false });

// Update price of a product
updateProductPrice(catalog, 101, 850);
updateProductPrice(catalog, 110, 444);

// Filter available products
filterAvailableProducts(catalog);

// Filter products by category
filterProductsByCategory(catalog, "Furniture");
