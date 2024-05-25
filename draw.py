import mysql.connector
import random

# Connect to the MySQL database
db = mysql.connector.connect(
    host="localhost",
    user="root",
    password="",
    database="cook_show"
)

cursor = db.cursor()

# Truncate tables
def truncate_tables():
    cursor.execute("SET foreign_key_checks = 0;")
    tables = [
        "participates_in", "score", "episode", "has_topic", "is_cooked_from", "comes_from"
    ]
    for table in tables:
        cursor.execute(f"TRUNCATE TABLE {table};")
    cursor.execute("SET foreign_key_checks = 1;")
    db.commit()
    print("Truncated specified tables.")

# Function to get all unique national cuisines
def get_unique_cuisines():
    cursor.execute("SELECT DISTINCT national_cuisine FROM recipe")
    cuisines = cursor.fetchall()
    return [c[0] for c in cuisines]

# Function to get all cooks
def get_all_cooks():
    cursor.execute("SELECT cook_id FROM cook")
    cooks = cursor.fetchall()
    return [c[0] for c in cooks]

# Function to get all recipes for a specific cuisine
def get_recipes_for_cuisine(cook_id, cuisine):
    cursor.execute("""
        SELECT recipe_id 
        FROM recipe 
        WHERE national_cuisine = %s 
        AND recipe_id NOT IN (
            SELECT recipe_id 
            FROM participates_in 
            JOIN score ON participates_in.cook_id = score.cook_id 
            WHERE participates_in.cook_id = %s
        )
    """, (cuisine, cook_id))
    recipes = cursor.fetchall()
    return [r[0] for r in recipes]

# Function to get all cooks that have not participated consecutively in the last 3 episodes and specialize in a specific cuisine
def get_available_cooks(episode_num, cuisine):
    if episode_num <= 3:
        cursor.execute("""
            SELECT cook.cook_id 
            FROM cook 
            JOIN specialization ON cook.cook_id = specialization.cook_id 
            WHERE specialization.specialization = %s
        """, (cuisine,))
    else:
        cursor.execute("""
            SELECT cook.cook_id 
            FROM cook 
            JOIN specialization ON cook.cook_id = specialization.cook_id 
            WHERE specialization.specialization = %s
            AND cook.cook_id NOT IN (
                SELECT cook_id 
                FROM participates_in 
                WHERE episode_id BETWEEN %s AND %s
            )
        """, (cuisine, episode_num - 3, episode_num - 1))
    cooks = cursor.fetchall()
    return [c[0] for c in cooks]

# Function to get all judges that have not participated consecutively in the last 3 episodes
def get_available_judges(episode_num):
    if episode_num <= 3:
        return get_all_cooks()  # Assuming all cooks can be judges too
    cursor.execute("""
        SELECT cook_id 
        FROM cook 
        WHERE cook_id NOT IN (
            SELECT cook_id 
            FROM participates_in 
            WHERE role = 'judge' AND episode_id BETWEEN %s AND %s
        )
    """, (episode_num - 3, episode_num - 1))
    judges = cursor.fetchall()
    return [j[0] for j in judges]

# Function to get all topics
def get_all_topics():
    cursor.execute("SELECT topic_name FROM topics")
    topics = cursor.fetchall()
    return [t[0] for t in topics]

# Function to create an episode
def create_episode(episode_num, season):
    while True:  # Keep trying until a valid episode is created
        cuisines = get_unique_cuisines()
        random.shuffle(cuisines)
        selected_cuisines = cuisines[:10]

        judges = get_available_judges(episode_num)
        random.shuffle(judges)
        selected_judges = judges[:3]

        if len(selected_judges) < 3:
            print(f"Not enough judges available for episode {episode_num}. Retrying...")
            continue

        used_cooks = set(selected_judges)  # Start with judges to avoid duplication
        participants = []

        for cuisine in selected_cuisines:
            available_cooks = get_available_cooks(episode_num, cuisine)
            random.shuffle(available_cooks)

            selected_cook = None
            for cook in available_cooks:
                if cook not in used_cooks:
                    selected_cook = cook
                    break

            if selected_cook is None:
                print(f"No available cook found for cuisine: {cuisine}. Retrying...")
                break  # Retry the entire episode creation

            recipes = get_recipes_for_cuisine(selected_cook, cuisine)
            if not recipes:
                print(f"No recipes found for cuisine: {cuisine} for cook {selected_cook}. Retrying...")
                break  # Retry the entire episode creation
            random.shuffle(recipes)
            selected_recipe = recipes[0]

            participants.append((selected_cook, selected_recipe, cuisine))
            used_cooks.add(selected_cook)
            print(f"Selected cook {selected_cook} for cuisine {cuisine}")

        if len(participants) < 5:
            print(f"Not enough participants to create the episode {episode_num}. Retrying...")
            continue

        # Insert episode
        cursor.execute("INSERT INTO episode (episode_number, season) VALUES (%s, %s)", (episode_num, season))
        episode_id = cursor.lastrowid
        print(f"Created episode {episode_id}")

        # Insert judges
        for judge in selected_judges:
            cursor.execute("INSERT INTO participates_in (cook_id, episode_id, role) VALUES (%s, %s, 'judge')", (judge, episode_id))
            print(f"Inserted judge {judge} into episode {episode_id}")

        # Insert participants
        for cook_id, recipe_id, cuisine in participants:
            try:
                cursor.execute("INSERT INTO participates_in (cook_id, episode_id, role) VALUES (%s, %s, 'chef')", (cook_id, episode_id))

                # Calculate and insert scores from judges
                judge_scores = [random.randint(1, 5) for _ in selected_judges]
                final_score = sum(judge_scores)
                cursor.execute("INSERT INTO score (cook_id, episode_id, recipe_id, final_score) VALUES (%s, %s, %s, %s)",
                               (cook_id, episode_id, recipe_id, final_score))
                score_triple_id = cursor.lastrowid

                # Insert each judge's score into comes_from table
                for judge, score in zip(selected_judges, judge_scores):
                    cursor.execute("INSERT INTO comes_from (score_triple_id, cook_id, score) VALUES (%s, %s, %s)",
                                   (score_triple_id, judge, score))

                cursor.execute("INSERT INTO is_cooked_from (cook_id, recipe_id) VALUES (%s, %s)", (cook_id, recipe_id))
                print(f"Inserted participant {cook_id} with recipe {recipe_id} for cuisine {cuisine} into episode {episode_id}")
            except mysql.connector.Error as err:
                print(f"Error: {err}. Failed to insert participant {cook_id} for episode {episode_id}")
                db.rollback()  # Rollback if there's any issue
                continue  # Retry the entire episode creation

        topics = get_all_topics()
        selected_topic = random.choice(topics)
        cursor.execute("INSERT INTO has_topic (episode_id, topic_name) VALUES (%s, %s)", (episode_id, selected_topic))
        print(f"Inserted topic '{selected_topic}' for episode {episode_id}")

        db.commit()
        print(f"Committed episode {episode_id}")
        break  # Exit the loop if episode creation is successful

# Main execution
truncate_tables()

# Create episodes
season = 2023
episodes_per_season = 10
seasons = 5

for year in range(seasons):
    for episode_num in range(1, episodes_per_season + 1):
        try:
            create_episode(episode_num + (year * episodes_per_season), season + year)
        except Exception as e:
            print(f"Failed to create episode {episode_num + (year * episodes_per_season)}: {e}")

# Ensure the 50th episode is created if not already created
if episode_num + (year * episodes_per_season) < episodes_per_season * seasons:
    try:
        create_episode(episodes_per_season * seasons, season + (episodes_per_season * seasons // episodes_per_season))
    except Exception as e:
        print(f"Failed to create the 50th episode: {e}")

# Close the connection
cursor.close()
db.close()
