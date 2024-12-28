Graded Assessment: MongoDB Scripts with Relationships

Scenario Overview:

You are working with an e-commerce platform. The platform has two collections:

1. Customers collection: Contains information about each customer.

2. Orders collection: Contains information about orders placed by customers.

Each customer can have multiple orders, but each order is linked to only one customer.


Part 1: Basic MongoDB Commands and Queries


1. Create the Collections and Insert Data:
  
     db.customers.insertMany([
    { 
        "_id": ObjectId(), 
        "name": "Vaibhav Rai", 
        "email": "vaibhavrai178@gmail.com", 
        "address": { 
            "street": "Gandhi St", 
            "city": "Hyderabad", 
            "zipcode": "123456" 
        }, 
        "phone": "1234567890", 
        "registration_date": ISODate("2024-12-09T09:00:00Z") 
    },
    { 
        "_id": ObjectId(), 
        "name": "King", 
        "email": "king@gmail.com", 
        "address": { 
            "street": "Mani St", 
            "city": "Secunderabad", 
            "zipcode": "123465" 
        }, 
        "phone": "1234657890", 
        "registration_date": ISODate("2024-10-01T12:22:00Z") 
    },
    { 
        "_id": ObjectId(), 
        "name": "Kocchar", 
        "email": "kocchar@gmail.com", 
        "address": { 
            "street": "Rayan St", 
            "city": "Secunderabad", 
            "zipcode": "123465" 
        }, 
        "phone": "1234658790", 
        "registration_date": ISODate("2024-10-09T22:09:10Z") 
    },
    { 
        "_id": ObjectId(), 
        "name": "Amaran", 
        "email": "amaran@gmail.com", 
        "address": { 
            "street": "Vinayaka St", 
            "city": "Proddatur", 
            "zipcode": "213465" 
        }, 
        "phone": "1234657809", 
        "registration_date": ISODate("2024-12-12T11:23:22Z") 
    },
    { 
        "_id": ObjectId(), 
        "name": "Sai", 
        "email": "sai@gmail.com", 
        "address": { 
            "street": "Sai St", 
            "city": "Proddatur", 
            "zipcode": "213465" 
        }, 
        "phone": "3214657890", 
        "registration_date": ISODate("2024-12-01T07:30:45Z") 
    }
]);



     db.orders.insertMany([
    { 
        "_id": ObjectId(), 
        "order_id": "ORD01", 
        "customer_id": ObjectId("00000065b40d5b20030d8190"),
        "order_date": ISODate("2024-12-09T09:00:00Z"), 
        "status": "shipped", 
        "items": [ 
            { "product_name": "Laptop", "quantity": 1, "price": 1500 }, 
            { "product_name": "Mouse", "quantity": 2, "price": 400 } 
        ], 
        "total_value": 2300 
    },
    { 
        "_id": ObjectId(), 
        "order_id": "ORD02", 
        "customer_id": ObjectId("00000066b40d5b20030d8191"),
        "order_date": ISODate("2024-10-01T12:22:00Z"), 
        "status": "pending", 
        "items": [ 
            { "product_name": "oven", "quantity": 1, "price": 800 }, 
            { "product_name": "Microwave", "quantity": 2, "price": 400 } 
        ], 
        "total_value": 1600 
    },
    { 
        "_id": ObjectId(), 
        "order_id": "ORD03", 
        "customer_id": ObjectId("00000067b40d5b20030d8192"),
        "order_date": ISODate("2024-10-09T22:09:10Z"), 
        "status": "delivered", 
        "items": [ 
            { "product_name": "Sofa", "quantity": 2, "price": 550 }, 
            { "product_name": "Chair", "quantity": 2, "price": 250 } 
        ], 
        "total_value": 1050 
    },
    { 
        "_id": ObjectId(), 
        "order_id": "ORD04", 
        "customer_id": ObjectId("00000068b40d5b20030d8193"),
        "order_date": ISODate("2024-12-12T11:23:22Z"), 
        "status": "shipped", 
        "items": [ 
            { "product_name": "Keyboard", "quantity": 1, "price": 920 }, 
            { "product_name": "Phone Case", "quantity": 1, "price": 200 } 
        ], 
        "total_value": 1020 
    },
    { 
        "_id": ObjectId(), 
        "order_id": "ORD05", 
        "customer_id": ObjectId("00000069b40d5b20030d8194"),
        "order_date": ISODate("2024-12-01T07:30:45Z"), 
        "status": "pending", 
        "items": [ 
            { "product_name": "Earpods", "quantity": 1, "price": 660 }, 
            { "product_name": "Charger", "quantity": 2, "price": 220 } 
        ], 
        "total_value": 1100 
    }
]);


2. Find Orders for a Specific Customer:

	  let customer = db.customers.findOne({name : "Sai"});
			customerId = customer._id;
			db.orders.find({"customer_id" : customerId});
		
		
3. Find the Customer for a Specific Order:
	
	  let order = db.orders.findOne({order_id : "ORD03"});
			customerId = order.customer_id;
			db.customers.find({_id : customerId});

4. Update Order Status:

	  db.orders.updateOne({"order_id" : "ORD05"},
		{$set : {"status" : "delivered"}}
		);
		
5. Delete an Order:

	  db.orders.deleteOne({order_id : "ORD02"});
		

Part 2: Aggregation Pipeline


1. Calculate Total Value of All Orders by Customer:

	  db.orders.aggregate([
    {
        $group: {
            _id: "$customer_id",
            totalOrderValue: { $sum: "$total_value" }
        }
    },
    {
        $lookup: {
            from: "customers",
            localField: "_id",
            foreignField: "_id",
            as: "customerDetails"
        }
    },
    {
        $project: {
            _id: 0,
            customerName: { $arrayElemAt: ["$customerDetails.name", 0] },
            totalOrderValue: 1
        }
    }
]);

2. Group Orders by Status:

	  db.orders.aggregate([
	{
		$group: {
			_id: "$status",
			numberOfOrders: {$sum: 1}}}
]);
	
3. List Customers with Their Recent Orders:

	  db.orders.aggregate([
    { 
        $sort: { order_date: -1 }
    },
    { 
        $group: { 
            _id: "$customer_id",
            mostRecentOrder: { $first: "$$ROOT" }
        }
    },
    { 
        $lookup: {
            from: "customers",
            localField: "_id",
            foreignField: "_id",
            as: "customerDetails"
        }},
    { 
        $project: { 
            _id: 0,
            customerName: { $arrayElemAt: ["$customerDetails.name", 0] },
            customerEmail: { $arrayElemAt: ["$customerDetails.email", 0] },
            orderId: "$mostRecentOrder.order_id",
            totalOrderValue: "$mostRecentOrder.total_value",
            orderDate: "$mostRecentOrder.order_date"
        }}
]);

4. Find the Most Expensive Order by Customer:

	  db.orders.aggregate([
    { 
        $sort: { order_date: -1 }
    },
    { 
        $group: { 
            _id: "$customer_id",
            mostRecentOrder: { $first: "$$ROOT" }
        }
    },
    { 
        $lookup: {
            from: "customers",
            localField: "_id",
            foreignField: "_id",
            as: "customerDetails"
        }},
    { 
        $project: { 
            _id: 0,
            customerName: { $arrayElemAt: ["$customerDetails.name", 0] },
            customerEmail: { $arrayElemAt: ["$customerDetails.email", 0] },
            orderId: "$mostRecentOrder.order_id",
            totalOrderValue: "$mostRecentOrder.total_value",
            orderDate: "$mostRecentOrder.order_date"
        }}
]);




