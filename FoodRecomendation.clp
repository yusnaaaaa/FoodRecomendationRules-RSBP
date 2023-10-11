; Create templates
(deftemplate Recipe
   (slot name)
   (slot cuisine)
   (slot difficulty)
   (slot ingredients)
   (slot instructions)
)

(deftemplate UserReview
   (slot recipe-name)
   (slot user-name)
   (slot review)
)

(deftemplate User
   (slot name)
   (slot cuisine-preference)
   (slot difficulty-preference)
   (slot ingredient-preference)
)

(deftemplate RecipeCreated
    (slot name) 
    (slot cuisine) 
    (slot difficulty) 
    (slot ingredients) 
)

(deftemplate RecipeOrdered
    (slot name) 
    (slot cuisine) 
    (slot difficulty) 
    (slot ingredients) 
)

; Create Rules

(defrule GetUserPreferences
    (not (User (name ?name)))
    =>
    ; inputs for user
    (printout t "insert your name !")
    (bind ?name (read))
    (if (eq ?name exit)
        then (exit) 
    else
        (printout t "Welcome, " ?name ". Let's find you a recipe!" crlf)
        (printout t "What cuisine do you prefer? ")
        (bind ?cuisine-pref (read))
        (printout t "How difficult should the recipe be? (Easy, Intermediate, Difficult) ")
        (bind ?difficulty-pref (read))
        (printout t "Do you have any specific ingredient preferences? ")
        (bind ?ingredient-pref (read))
        ; create new user fact
        (assert (User 
            (name ?name)
            (difficulty-preference ?difficulty-pref)
            (cuisine-preference ?cuisine-pref)
            (ingredient-preference ?ingredient-pref)
            ))
    )
)

(defrule RecommendRecipe
    (User 
        (name ?name)
        (cuisine-preference ?cuisine-pref)
        (difficulty-preference ?difficulty-pref)
        (ingredient-preference ?ingredient-pref)
    )
    (Recipe 
        (name ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
    )
    (test (eq ?cuisine ?cuisine-pref))
    (test (eq ?difficulty ?difficulty-pref))
    =>
    (printout t "Based on your preferences, we recommend: " ?recipe crlf)
    (printout t "Ingredients: " ?ingredients crlf)
    (printout t "Enjoy your meal!" crlf)
    
    (assert (RecipeRecommended))
    (assert (RecipeCreated
        (name ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
    ))
    (assert (RecipeOrdered
        (name ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
    ))
    
)

(defrule RecomendationNotFound
    (not (RecipeRecommended))
    =>
    (printout t "Sorry, There's no Recomendation food for you." crlf)
)

(defrule UserReview
    (User 
        (name ?user-name)
        (cuisine-preference ?cuisine-pref)
        (difficulty-preference ?difficulty-pref)
        (ingredient-preference ?ingredient-pref)
    )
    ?recipeOrdered <-   (RecipeOrdered 
        (name ?recipe)
        (cuisine ?cuisine)
        (difficulty ?difficulty)
        (ingredients ?ingredients)
    )
    (RecipeRecommended)
    =>
    (printout t "Please write your review for our menu here: ")
    (bind ?review (read))
    (assert (UserReview (recipe-name ?recipe) (user-name ?user-name) (review ?review)))
    (printout t "Thanks for reviewed our food!" crlf)
    (retract ?recipeOrdered)    
)

(defrule DisplayRecipeInstructions
    (User (name ?name))
    (Recipe (name ?recipe) (instructions ?instructions))
    =>
    (printout t "You can view the instructions for a specific recipe. Please provide the recipe name:" crlf)
    (printout t "Recipe name: ")
    (bind ?recipe-name (read))
    (if (eq ?recipe ?recipe-name)
        then
        (printout t "Instructions for " ?recipe ":" crlf)
        (printout t ?instructions crlf)
        else
        (printout t "Recipe not found." crlf)
    )
)

(defrule ExitRecommendation
   ?user <- (User (name ?name))
   ?recom <- (RecipeRecommended)
   =>
   (printout t "Thank you for using the personalized recipe recommender, " ?name "!" crlf)
   (printout t "Explore more recipes and share your thoughts. Enjoy your meals!" crlf)
   ;(retract ?recom)
   ;(retract ?user)
   ;(exit)
)

; set initial facts

(deffacts SampleRecipes
    (Recipe 
        (name "Spaghetti Carbonara") 
        (cuisine Italian) 
        (difficulty Easy)
        (ingredients "spaghetti, eggs, bacon, Parmesan cheese") 
        (instructions "1. Cook spaghetti. 2. Fry bacon. 3. Mix eggs and cheese. 4. Toss with pasta.")
    )

    (Recipe 
        (name "Chicken Tikka Masala") 
        (cuisine Indian) 
        (difficulty Intermediate)
        (ingredients "chicken, yogurt, tomato sauce, spices") 
        (instructions "1. Marinate chicken. 2. Cook chicken. 3. Simmer in sauce.")
    )

    (Recipe 
        (name "Caesar Salad") 
        (cuisine American) 
        (difficulty Easy)
        (ingredients "romaine lettuce, croutons, Caesar dressing") 
        (instructions "1. Toss lettuce with dressing. 2. Add croutons.")
    )

    (Recipe 
        (name "Margherita Pizza") 
        (cuisine Italian) 
        (difficulty Easy)
        (ingredients "pizza dough, tomatoes, mozzarella, basil") 
        (instructions "1. Roll out dough. 2. Add toppings. 3. Bake until crispy.")
    )

    (Recipe 
        (name "Beef Stir-Fry") 
        (cuisine Chinese) 
        (difficulty Intermediate)
        (ingredients "beef, vegetables, soy sauce, ginger") 
        (instructions "1. Stir-fry beef and vegetables. 2. Add soy sauce and ginger.")
    )

    (Recipe 
        (name "Chicken Alfredo") 
        (cuisine Italian) 
        (difficulty Intermediate)
        (ingredients "chicken, fettuccine, Alfredo sauce") 
        (instructions "1. Cook chicken. 2. Boil fettuccine. 3. Mix with Alfredo sauce.")
    )

    (Recipe 
        (name "Gazpacho") 
        (cuisine Spanish) 
        (difficulty Easy)
        (ingredients "tomatoes, cucumbers, bell peppers, onions") 
        (instructions "1. Blend vegetables. 2. Chill before serving.")
    )

    (Recipe 
        (name "Sushi Rolls") 
        (cuisine Japanese) 
        (difficulty Intermediate)
        (ingredients "rice, fish, seaweed, vegetables") 
        (instructions "1. Prepare rice and ingredients. 2. Roll sushi.")
    )

    (Recipe 
        (name "Chocolate Cake") 
        (cuisine Dessert) 
        (difficulty Easy)
        (ingredients "flour, sugar, cocoa, eggs") 
        (instructions "1. Mix dry and wet ingredients. 2. Bake until done.")
    )

    (Recipe 
        (name "Greek Salad") 
        (cuisine Greek) 
        (difficulty Easy)
        (ingredients "cucumbers, tomatoes, olives, feta cheese") 
        (instructions "1. Combine ingredients. 2. Add dressing.")
    )
)