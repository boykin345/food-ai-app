| User Story Code | Feature / Component | Test Case Description | Test Status | Implementation Status | Refactoring Notes |
|-----------------|-----------|-----------------------|-------------|-----------------------|--|
| I               | **Meal/Tinder Selection** | | | | |
| I1/2              | - Index Initialization   | Test if the index is initialized correctly at 0                                                    | Pass             | Done                  |  |
| I1/2             | - Index Increment        | Test if the index is incremented correctly                                                         | Pass             | Done                  |  |
| I1/2            | - Get Initial Description| Test if `getRecipeDescription` retrieves the initial description correctly                         | Pass             | Done                  |  |
| I1/2            | - Get Initial Image      | Test if `getRecipeImage` retrieves the initial image correctly                                     | Pass             | Done                  |  |
| I1/2            | - Add Recipe Handling    | Test if adding a recipe handles null values correctly by throwing a `FormatException`              | Pass             | Done                  |  |
| I1/2            | - Fetch Recipes Update   | Test if `fetchRecipes` updates recipe descriptions and images lists correctly after changing recipe  | Pass           | Done                  | |
| I1/2            | - Recipe List Addition   | Test if changing recipes adds items to the relevant lists correctly after index crosses threshold  | Pass           | Done                  |  |
| I1/2            | - Recipe Change Handling | Test if changing recipe updates the pointer/index correctly                                        | Pass             | Done                  |  |
| I1/2            | - Pointer Reset          | Test if the pointer/index resets correctly after reaching the threshold                            | Pass             | Done                  |  |
| I1/2            | - Tinder Controller      | Test if `initialize()` populates model with recipes and images                                | Pass        | Done                  |                   |
| I1/2            | - Tinder Controller      | Test if `changeRecipe()` removes current recipe and fetches new one                           | Pass        | Done                  |                   |
| I1/2            | - Tinder Model           | Test if model is empty before initialization                                                  | Pass        | Done                  |                   |
| I1/2            | - Tinder Controller      | Test if `fetchRecipes` adds new recipe and image to model                                     | Pass        | Done                  |                   |
| I1/2            | - Tinder Controller      | Test if `changeRecipe` does not throw when there is no data                                   | Pass        | Done                  |                   |
| I1/2            | - Tinder Controller      | Test if `initialize()` successfully initializes model with data                               | Pass        | Done                  |                   |
| I1/2            | - Tinder Controller      | Test if `createView()` returns a TinderView with correct model and callback                   | Pass        | Done                  |                   |
| I1/2            | - Tinder Controller      | Test if `initRecipes()` successfully fetches and adds recipes and images to model             | Pass        | Done                  |                   |
| II1             | - Data Display           | Test if data is loaded and displayed correctly                                                | Pass        | Done                  |                   |
| II2             | - Swipe Right Interaction| Test if swiping right triggers `onChangeRecipe` callback                                      | Pass        | Done                  |                   |
| II3             | - Model Change UI Update | Test if UI updates correctly when model data changes                                          | Pass        | Done                  |                   |
| II4             | - Loading Indicator      | Test if loading indicator is displayed when data is loading                                   | Pass        | Done                  |                   |
| II5             | - No Button Interaction  | Test if clicking the no button triggers `onChangeRecipe` callback                             | Pass  | Done                  |                   |