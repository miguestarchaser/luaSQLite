--[[
		Libreria de funciones SQLite de WayakStudios	
		autor: MigueStarchaser
		Diciembre 2016
]]--

--Database
local connection  = {};

function connectDB( dbName )
	local sqlite3 	  		= require( "sqlite3" );
	local database	  		= dbName;
	local path 		    	= system.pathForFile( database , system.DocumentsDirectory );
	--local path 		  	= system.pathForFile( database , system.ResourceDirectory );
	local db 		      	= sqlite3.open( path );
	connection		    	= db;
end

function closeDB(  )
	if(type(connection) == "userdata") then
		connection:close();
	end
	connection = {};
end

function testDB(table)
	local query 	= "SELECT count(*) FROM sqlite_master WHERE type = 'table' AND name = '"..table.."';"
	local response 	= executeQuery(query);
	return response;
end

function executeQuery(query)
	local  	response = connection:exec( query );
	if(response == 1) then 
		print(query);
	end	
	if connection:errcode() then
		print(connection:errcode(), connection:errmsg())
	end
	return 	response;
end	

function getData(table,condition)
	local query = "SELECT * FROM "..table;
	if(condition ~= nil) then
		query = query.." WHERE "..condition.."'";
	end
	local data  = {};
	for row in connection:nrows(query) do
		data[#data+1] = row;		
	end
	return data;
end	

function insertData(table,data)
	local query 	= "INSERT INTO `"..table.."` ({fields}) VALUES({values});";
	local fields	= "";
	local values 	= "";
	if(type(data) == "table") then 
		for k,v in pairs(data) do
			if(fields == "") then
				fields = fields.."`"..k.."`";
				values = values.."'"..v.."'";
			else
				fields = fields..", `"..k.."`";
				values = values..", '"..v.."'";
			end	
		end	
	end	
	query = query.gsub(query,"{fields}",fields);
	query = query.gsub(query,"{values}",values);
	local response = executeQuery(query);
end	

function updateValue(table,field,value,condition)
	local query = "UPDATE `"..table.."` SET `"..field.."` = "..value.." WHERE "..condition;
	executeQuery(query);
end	

function updateValues(table,data,condition)
	local query = "UPDATE `"..table.."` SET";
	local sets	= "";
	for k,v in pairs(data) do 
		if(sets == "") then 
			sets = sets.." `"..k.."`  = '"..v.."'";
		else
			sets = sets..", `"..k.."` = '"..v.."'";
		end	
	end
	query = query..sets
	if(condition ~= nil) then
		query = query.." WHERE "..condition;
	end
	executeQuery(query);
end

function getArray(query)
	local data 		= {}; 
	for row in db:nrows(query) do
		data[#data+1] = row;		
	end
	return data;
end	
