import mysql.connector

# Connect to the MySQL database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="9999",
    database="cook_show"
)

def execute_query(query, params=None):
    cursor = db.cursor(dictionary=True)
    cursor.execute(query, params)
    result = cursor.fetchall()
    db.commit()
    cursor.close()
    return result

def run_custom_query(user_role, cook_id=None):
    allowed_queries = ["UPDATE", "INSERT", "SELECT"]

    while True:
        query = input("Enter your SQL query (or type 'exit' to go back to the menu): ")
        if query.lower() == 'exit':
            break
        query_type = query.split()[0].upper()

        if user_role == 'admin' or (query_type in allowed_queries and validate_query(query, cook_id)):
            try:
                result = execute_query(query)
                if result:
                    for row in result:
                        print(row)
                else:
                    if query_type == 'SELECT':
                        print("No rows returned.")
                    else:
                        print("Query executed successfully.")
            except mysql.connector.Error as err:
                print(f"Error: {err}")
        else:
            print("You are not allowed to execute this query.")

def validate_query(query, cook_id):
    """
    Validates the query for a cook to ensure they can only:
    a) Update their personal details
    b) Change their assigned recipes
    c) Add new recipes
    d) Select their own info from cook and is_cooked_from tables
    e) Select recipes
    """
    query = query.strip().upper()

    # Ensure the cook can only update their own personal details
    if query.startswith("UPDATE COOK"):
        if f"WHERE COOK_ID = {cook_id}" in query:
            return True
        else:
            return False

    # Ensure the cook can only update recipes assigned to them
    elif query.startswith("UPDATE RECIPE"):
        return True  # Further validation can be added to check specific recipe assignment

    # Ensure the cook can only insert into recipe or is_cooked_from tables
    elif query.startswith("INSERT INTO RECIPE") or query.startswith("INSERT INTO IS_COOKED_FROM"):
        return True

    # Ensure the cook can only select their own info from cook table
    elif query.startswith("SELECT * FROM COOK"):
        if f"WHERE COOK_ID = {cook_id}" in query:
            return True
        else:
            return False

    # Ensure the cook can only select their own entries in is_cooked_from
    elif query.startswith("SELECT * FROM IS_COOKED_FROM"):
        if f"WHERE COOK_ID = {cook_id}" in query:
            return True
        else:
            return False

    # Allow select queries for viewing recipes
    elif query.startswith("SELECT * FROM RECIPE"):
        return True

    # Deny all other types of queries
    return False

def register_user(username, password, role):
    query = "INSERT INTO users (username, password, role) VALUES (%s, %s, %s)"
    execute_query(query, (username, password, role))
    print(f"User {username} registered successfully.")

def login_user(username, password):
    query = "SELECT * FROM users WHERE username = %s AND password = %s"
    result = execute_query(query, (username, password))
    if result:
        user = result[0]
        print("Login successful.")
        return {'user_id': user['user_id'], 'username': user['username'], 'role': user['role']}
    else:
        print("Invalid username or password.")
        return None

def get_cook_info(cook_id):
    query = "SELECT * FROM cook WHERE cook_id = %s"
    result = execute_query(query, (cook_id,))
    if result:
        return result[0]
    else:
        return None

def get_cook_recipes(cook_id):
    query = """
    SELECT recipe.recipe_id, recipe.name 
    FROM recipe 
    INNER JOIN is_cooked_from ON recipe.recipe_id = is_cooked_from.recipe_id 
    WHERE is_cooked_from.cook_id = %s
    """
    result = execute_query(query, (cook_id,))
    return result

def recipe_is_assigned_to_cook(cook_id, recipe_id):
    query = "SELECT * FROM is_cooked_from WHERE cook_id = %s AND recipe_id = %s"
    result = execute_query(query, (cook_id, recipe_id))
    print(f"Query Result for recipe_is_assigned_to_cook: {result}")  # Debugging line
    return len(result) > 0

def update_recipe(cook_id, recipe_id, column_to_update, new_value):
    valid_columns = ["name", "description", "difficulty", "national_cuisine", "preparation_time", "cooking_time", "type", "portions"]

    if column_to_update not in valid_columns:
        print("Invalid action.")
        return

    if recipe_is_assigned_to_cook(cook_id, recipe_id):
        # Allow update
        query = f"UPDATE recipe SET {column_to_update} = %s WHERE recipe_id = %s"
        execute_query(query, (new_value, recipe_id))
        print("Recipe updated successfully.")
    else:
        raise PermissionError("You are not allowed to update this recipe.")

def update_personal_info(cook_id):
    valid_columns = ["name", "surname", "tel", "birth_date", "age", "experience", "cook_level"]
    column_to_update = input(f"Enter the column you want to update ({', '.join(valid_columns)}): ")

    if column_to_update not in valid_columns:
        print("Invalid action.")
        return

    new_value = input(f"Enter new value for {column_to_update}: ")

    query = f"UPDATE cook SET {column_to_update} = %s WHERE cook_id = %s"
    execute_query(query, (new_value, cook_id))
    print(f"{column_to_update} updated successfully.")


def add_recipe(cook_id):
    new_recipe = {}

    def get_input(prompt):
        value = input(prompt)
        if value.lower() == 'exit':
            print("Exiting to menu.")
            return None
        return value

    new_recipe['name'] = get_input("Enter recipe name (or type 'exit' to return to menu): ")
    if new_recipe['name'] is None:
        return

    new_recipe['description'] = get_input("Enter recipe description (or type 'exit' to return to menu): ")
    if new_recipe['description'] is None:
        return

    new_recipe['difficulty'] = get_input("Enter recipe difficulty (1-5, or type 'exit' to return to menu): ")
    if new_recipe['difficulty'] is None:
        return

    new_recipe['national_cuisine'] = get_input("Enter recipe national cuisine (or type 'exit' to return to menu): ")
    if new_recipe['national_cuisine'] is None:
        return

    new_recipe['preparation_time'] = get_input("Enter preparation time (or type 'exit' to return to menu): ")
    if new_recipe['preparation_time'] is None:
        return

    new_recipe['cooking_time'] = get_input("Enter cooking time (or type 'exit' to return to menu): ")
    if new_recipe['cooking_time'] is None:
        return

    new_recipe['type'] = get_input("Enter recipe type (or type 'exit' to return to menu): ")
    if new_recipe['type'] is None:
        return

    new_recipe['portions'] = get_input("Enter number of portions (or type 'exit' to return to menu): ")
    if new_recipe['portions'] is None:
        return

    query = """
    INSERT INTO recipe (name, description, difficulty, national_cuisine, 
    preparation_time, cooking_time, type, portions) 
    VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
    """
    execute_query(query, (
        new_recipe['name'], new_recipe['description'], new_recipe['difficulty'],
        new_recipe['national_cuisine'], new_recipe['preparation_time'], 
        new_recipe['cooking_time'], new_recipe['type'], new_recipe['portions']
    ))

    # Get the last inserted recipe_id
    query = "SELECT LAST_INSERT_ID() AS recipe_id"
    result = execute_query(query)
    recipe_id = result[0]['recipe_id']

    # Link the new recipe with the cook
    query = "INSERT INTO is_cooked_from (cook_id, recipe_id) VALUES (%s, %s)"
    execute_query(query, (cook_id, recipe_id))

    print("Recipe added and linked to cook successfully.")

def cook_menu(cook_id):
    while True:
        print("\nMenu:")
        print("a) Update personal details")
        print("b) Change something in the recipe you are cooking")
        print("c) Add a new recipe")
        print("d) Run your own query")
        print("e) Exit")
        choice = input("Choose an option (a/b/c/d/e): ")

        if choice == 'a':
            update_personal_info(cook_id)
        elif choice == 'b':
            recipes = get_cook_recipes(cook_id)
            if recipes:
                print("You can update the following recipes:")
                recipe_names = [recipe['name'] for recipe in recipes]
                for name in recipe_names:
                    print(name)
                recipe_name = input("Enter the recipe name you want to update: ")
                selected_recipe = next((recipe for recipe in recipes if recipe['name'] == recipe_name), None)
                if selected_recipe:
                    valid_columns = ["name", "description", "difficulty", "national_cuisine", "preparation_time", "cooking_time", "type", "portions"]
                    column_to_update = input(f"Enter the column you want to update ({', '.join(valid_columns)}): ")

                    if column_to_update not in valid_columns:
                        print("Invalid action.")
                    else:
                        new_value = input(f"Enter new value for {column_to_update}: ")
                        try:
                            update_recipe(cook_id, selected_recipe['recipe_id'], column_to_update, new_value)
                        except PermissionError as e:
                            print(e)
                else:
                    print("Invalid recipe name.")
            else:
                print("No recipes assigned to you.")
        elif choice == 'c':
            try:
                add_recipe(cook_id)
            except PermissionError as e:
                print(e)
        elif choice == 'd':
            run_custom_query('cook', cook_id)
        elif choice == 'e':
            break
        else:
            print("Invalid choice. Please try again.")


def admin_menu():
    while True:
        print("\nAdmin Menu:")
        print("a) Run your own query")
        print("b) Exit")
        choice = input("Choose an option (a/b): ")

        if choice == 'a':
            run_custom_query('admin')
        elif choice == 'b':
            break
        else:
            print("Invalid choice. Please try again.")

# Example usage
def main():
    # Register a new user (only needed once, then comment out)
    #register_user('admin', 'admin', 'admin')
    #register_user('cook', 'cook', 'cook')

    # Login
    username = input("Enter username: ")
    password = input("Enter password: ")

    user = login_user(username, password)
    if not user:
        return

    if user['role'] == 'cook':
        cook_id = int(input("Enter your cook ID: "))
        cook_info = get_cook_info(cook_id)
        if cook_info and cook_info['cook_id'] == cook_id:
            cook_menu(cook_id)
        else:
            print("Invalid cook ID.")
    elif user['role'] == 'admin':
        admin_menu()
    else:
        print("Unknown role. Exiting.")

if __name__ == "__main__":
    main()
