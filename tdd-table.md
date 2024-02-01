| User Story Code | Feature / Component | Test Case Description | Test Status | Implementation Status | Refactoring Notes |
|-----------------|-----------|-----------------------|-------------|-----------------------|--|
| I               | **Meal/Tinder Selection** | | | | |
| I1/2              | - Index Initialization   | Test if the index is initialized correctly at 0                                                    | Pass             | Done                  |  |
| I1/2             | - Index Increment        | Test if the index is incremented correctly                                                         | Pass             | Done                  |  |
| I1/2            | - Get Initial Description| Test if `getRecipeDescription` retrieves the initial description correctly                         | Pass             | Done                  |  |
| I1/2            | - Get Initial Image      | Test if `getRecipeImage` retrieves the initial image correctly                                     | Pass             | Done                  |  |
| I1/2            | - Add Recipe Handling    | Test if adding a recipe handles null values correctly by throwing a `FormatException`            | Pass             | Done                  |  |
| I1/2            | - Fetch Recipes Update   | Test if `fetchRecipes` updates recipe descriptions and images lists correctly after changing recipe | Pass           | Done                  | |
| I1/2            | - Recipe List Addition   | Test if changing recipes adds items to the relevant lists correctly after index crosses threshold  | Pass           | Done                  |  |
| I1/2            | - Recipe Change Handling | Test if changing recipe updates the pointer/index correctly                                        | Pass             | Done                  |  |
| I1/2            | - Pointer Reset          | Test if the pointer/index resets correctly after reaching the threshold                            | Pass             | Done                  |  |
