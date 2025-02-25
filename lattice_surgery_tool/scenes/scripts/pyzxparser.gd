extends Node3D

func _ready():
	# Scaling factor to spread out the visualization
	var scale = 2.0
	
	# Define vertices from the JSON data
	var vertices = [
		{"id": 0, "t": 0, "pos": [0, 0]},  # Input (control)
		{"id": 1, "t": 0, "pos": [0, 1]},  # Input (target)
		{"id": 2, "t": 2, "pos": [1, 1]},  # X-spider
		{"id": 3, "t": 1, "pos": [1, 0]},  # Z-spider
		{"id": 4, "t": 0, "pos": [2, 0]},  # Output (control)
		{"id": 5, "t": 0, "pos": [2, 1]}   # Output (target)
	]
	
	# Define edges from the JSON data
	var edges = [
		[0, 3],  # Input 0 to Z-spider
		[1, 2],  # Input 1 to X-spider
		[2, 3],  # X-spider to Z-spider
		[2, 5],  # X-spider to Output 5
		[3, 4]   # Z-spider to Output 4
	]
	
	# Create materials
	var black_material = StandardMaterial3D.new()
	black_material.albedo_color = Color(0, 0, 0)  # Black for inputs/outputs and block
	
	var green_material = StandardMaterial3D.new()
	green_material.albedo_color = Color(0, 1, 0)  # Green for Z-spider
	
	var red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color(1, 0, 0)    # Red for X-spider
	
	var gray_material = StandardMaterial3D.new()
	gray_material.albedo_color = Color(0.5, 0.5, 0.5)  # Gray for prisms
	
	# Create cubes for each vertex
	for v in vertices:
		var cube = MeshInstance3D.new()
		cube.mesh = BoxMesh.new()
		cube.mesh.size = Vector3(1, 1, 1)  # Cube size
		cube.transform.origin = Vector3(scale * v["pos"][0], scale * v["pos"][1], 0)
		# Assign material based on vertex type
		if v["t"] == 0:
			cube.material_override = black_material
		elif v["t"] == 1:
			cube.material_override = green_material
		elif v["t"] == 2:
			cube.material_override = red_material
		add_child(cube)
	
	# Create prisms and block for edges
	for e in edges:
		var v1 = vertices[e[0]]
		var v2 = vertices[e[1]]
		var pos1 = v1["pos"]
		var pos2 = v2["pos"]
		
		# Horizontal edge (same row)
		if pos1[1] == pos2[1]:
			var x1 = scale * pos1[0]
			var x2 = scale * pos2[0]
			var y = scale * pos1[1]
			var center_x = (x1 + x2) / 2
			var size_x = abs(x2 - x1)
			var prism = MeshInstance3D.new()
			prism.mesh = BoxMesh.new()
			prism.mesh.size = Vector3(size_x, 0.2, 0.2)  # Thin prism
			prism.transform.origin = Vector3(center_x, y, 0)
			prism.material_override = gray_material
			add_child(prism)
		
		# Vertical edge (same column)
		elif pos1[0] == pos2[0]:
			var x = scale * pos1[0]
			var y1 = scale * pos1[1]
			var y2 = scale * pos2[1]
			var y_min = min(y1, y2)
			var y_max = max(y1, y2)
			var midpoint = (y_min + y_max) / 2
			
			# Add the additional block
			var block = MeshInstance3D.new()
			block.mesh = BoxMesh.new()
			block.mesh.size = Vector3(0.2, 0.2, 0.2)  # Small cube
			block.transform.origin = Vector3(x, midpoint, 0)
			block.material_override = black_material
			add_child(block)
			
			# Add prisma from lower vertex to block
			var prism1 = MeshInstance3D.new()
			prism1.mesh = BoxMesh.new()
			prism1.mesh.size = Vector3(0.2, midpoint - y_min, 0.2)
			prism1.transform.origin = Vector3(x, (y_min + midpoint) / 2, 0)
			prism1.material_override = gray_material
			add_child(prism1)
			
			# Add prism from block to upper vertex
			var prism2 = MeshInstance3D.new()
			prism2.mesh = BoxMesh.new()
			prism2.mesh.size = Vector3(0.2, y_max - midpoint, 0.2)
			prism2.transform.origin = Vector3(x, (midpoint + y_max) / 2, 0)
			prism2.material_override = gray_material
			add_child(prism2)
