function genID() {
    return UUID().toString().split('"')[1]
}

db.pbehavior_type.insertMany([
    {
        "_id": "default_inactive",
        "loader_id": "default_inactive",
        "name": "Default inactive",
        "description": "Default inactive",
        "icon_name": "brightness_3",
        "priority": 0,
        "type": "inactive"
    },
    {
        "_id": "default_active",
        "loader_id": "default_active",
        "name": "Default active",
        "description": "Default active",
        "icon_name": "",
        "priority": 1,
        "type": "active"
    },
    {
        "_id": "default_maintenance",
        "loader_id": "default_maintenance",
        "name": "Default maintenance",
        "description": "Default maintenance",
        "icon_name": "build",
        "priority": 2,
        "type": "maintenance"
    },
    {
        "_id": "default_pause",
        "loader_id": "default_pause",
        "name": "Default pause",
        "description": "Default pause",
        "icon_name": "pause",
        "priority": 3,
        "type": "pause"
    }
]);
