//
//  MealCatalog.swift
//  NexusWorkout
//
//  35 meal templates — 7 days × 5 meal slots (breakfast, mid-morning,
//  lunch, snack, dinner).  Daily totals target the plan's macros:
//
//      ~1,980 kcal | 180 g protein | 180 g carbs | 60 g fat
//
//  Indian, chicken-eater, no beef / no fish.  Dishes lean on eggs,
//  paneer, chicken, dal, curd, oats, multigrain rotis — things a Mumbai
//  kitchen actually has.  Macros are rounded; the daily total is the
//  number that matters, not any single meal.
//
//  mealType uses these tokens (Models.swift comment):
//      "breakfast" | "snack" | "lunch" | "snack" | "dinner"
//      (mid-morning + afternoon are both `snack`; the slot is implied
//       by `suggestedTime`)
//

import Foundation

enum MealCatalog {

    static func all() -> [MealTemplate] {
        [
            // ───────────────── Day 1 — Monday ─────────────────
            MealTemplate(
                name: "Egg Bhurji + Multigrain Roti",
                dayOfWeek: 1, mealType: "breakfast",
                items: "4 whole eggs + 4 egg whites scrambled with onion, tomato, green chilli; 2 multigrain rotis; 1 tbsp tomato chutney.",
                calories: 480, protein: 42, carbs: 38, fat: 16,
                suggestedTime: "08:00"
            ),
            MealTemplate(
                name: "Greek Yoghurt + Whey + Berries",
                dayOfWeek: 1, mealType: "snack",
                items: "Greek yoghurt 200 g; whey isolate 1 scoop (30 g); ½ cup mixed berries.",
                calories: 260, protein: 32, carbs: 22, fat: 4,
                suggestedTime: "11:00"
            ),
            MealTemplate(
                name: "Chicken Curry + Brown Rice + Dal",
                dayOfWeek: 1, mealType: "lunch",
                items: "Chicken curry 200 g (low-oil); 1 cup cooked brown rice; 1 cup yellow dal; cucumber-onion salad.",
                calories: 580, protein: 48, carbs: 60, fat: 14,
                suggestedTime: "13:30"
            ),
            MealTemplate(
                name: "Roasted Chana + Apple",
                dayOfWeek: 1, mealType: "snack",
                items: "Roasted chana 50 g; 1 medium apple; 20 g almonds.",
                calories: 320, protein: 14, carbs: 38, fat: 12,
                suggestedTime: "17:00"
            ),
            MealTemplate(
                name: "Tandoori Chicken + Jeera Rice",
                dayOfWeek: 1, mealType: "dinner",
                items: "Tandoori chicken 200 g; ½ cup jeera rice; sautéed palak; cucumber raita.",
                calories: 460, protein: 48, carbs: 32, fat: 14,
                suggestedTime: "20:30"
            ),

            // ───────────────── Day 2 — Tuesday ─────────────────
            MealTemplate(
                name: "Oats + Whey + Banana",
                dayOfWeek: 2, mealType: "breakfast",
                items: "60 g rolled oats cooked in 250 ml skim milk; 1 scoop whey; 1 banana sliced in.",
                calories: 510, protein: 42, carbs: 65, fat: 8,
                suggestedTime: "08:00"
            ),
            MealTemplate(
                name: "Paneer Cubes + Cucumber",
                dayOfWeek: 2, mealType: "snack",
                items: "Paneer 100 g (low-fat) tossed with chaat masala; cucumber slices; black coffee.",
                calories: 220, protein: 22, carbs: 6, fat: 12,
                suggestedTime: "11:00"
            ),
            MealTemplate(
                name: "Egg Curry + Roti + Sabzi",
                dayOfWeek: 2, mealType: "lunch",
                items: "Egg curry (4 eggs) in tomato gravy; 2 multigrain rotis; mixed-veg sabzi; ½ cup dal.",
                calories: 600, protein: 44, carbs: 50, fat: 22,
                suggestedTime: "13:30"
            ),
            MealTemplate(
                name: "Chickpea Chaat",
                dayOfWeek: 2, mealType: "snack",
                items: "Boiled chickpeas 1 cup tossed with onion, tomato, lemon, chaat masala; 1 orange.",
                calories: 280, protein: 18, carbs: 42, fat: 4,
                suggestedTime: "17:00"
            ),
            MealTemplate(
                name: "Chicken Stir-fry + Sweet Potato",
                dayOfWeek: 2, mealType: "dinner",
                items: "Chicken breast 200 g stir-fried with capsicum + broccoli; 200 g roasted sweet potato; green salad.",
                calories: 470, protein: 52, carbs: 40, fat: 10,
                suggestedTime: "20:30"
            ),

            // ───────────────── Day 3 — Wednesday ─────────────────
            MealTemplate(
                name: "Besan Chilla + Paneer Filling",
                dayOfWeek: 3, mealType: "breakfast",
                items: "3 besan chillas stuffed with paneer 100 g, onion, coriander; mint-coriander chutney.",
                calories: 490, protein: 38, carbs: 38, fat: 18,
                suggestedTime: "08:00"
            ),
            MealTemplate(
                name: "Whey + Apple + PB Toast",
                dayOfWeek: 3, mealType: "snack",
                items: "Whey shake 30 g in water; 1 apple; 1 rice cake with 15 g peanut butter.",
                calories: 290, protein: 28, carbs: 30, fat: 8,
                suggestedTime: "11:00"
            ),
            MealTemplate(
                name: "Grilled Chicken + Quinoa",
                dayOfWeek: 3, mealType: "lunch",
                items: "Grilled chicken breast 200 g; 1 cup cooked quinoa; steamed veg; ½ cup curd.",
                calories: 560, protein: 52, carbs: 50, fat: 14,
                suggestedTime: "13:30"
            ),
            MealTemplate(
                name: "Sprouts Bhel",
                dayOfWeek: 3, mealType: "snack",
                items: "Mixed sprouts bhel (moong + chana) 1 cup; 25 g cashews.",
                calories: 280, protein: 16, carbs: 30, fat: 10,
                suggestedTime: "17:00"
            ),
            MealTemplate(
                name: "Paneer Bhurji + Roti + Dal Palak",
                dayOfWeek: 3, mealType: "dinner",
                items: "Paneer bhurji 150 g; 2 multigrain rotis; dal palak 1 bowl.",
                calories: 470, protein: 42, carbs: 42, fat: 14,
                suggestedTime: "20:30"
            ),

            // ───────────────── Day 4 — Thursday ─────────────────
            MealTemplate(
                name: "Veg Omelette + Brown Bread",
                dayOfWeek: 4, mealType: "breakfast",
                items: "Omelette: 5 egg whites + 3 yolks + onion + tomato + spinach; 2 slices brown bread; tomato slices.",
                calories: 470, protein: 42, carbs: 36, fat: 16,
                suggestedTime: "08:00"
            ),
            MealTemplate(
                name: "Yoghurt + Whey + Walnuts",
                dayOfWeek: 4, mealType: "snack",
                items: "Greek yoghurt 200 g; ⅔ scoop whey (20 g); 15 g walnuts.",
                calories: 290, protein: 28, carbs: 14, fat: 12,
                suggestedTime: "11:00"
            ),
            MealTemplate(
                name: "Homestyle Chicken Biryani",
                dayOfWeek: 4, mealType: "lunch",
                items: "Chicken biryani 1 plate (150 g rice + 200 g chicken, low-oil); cucumber raita; 1 boiled egg.",
                calories: 620, protein: 52, carbs: 60, fat: 16,
                suggestedTime: "13:30"
            ),
            MealTemplate(
                name: "Cottage Cheese + Pear",
                dayOfWeek: 4, mealType: "snack",
                items: "Cottage cheese (paneer-style, low-fat) 100 g; 1 pear.",
                calories: 230, protein: 22, carbs: 22, fat: 6,
                suggestedTime: "17:00"
            ),
            MealTemplate(
                name: "Chicken Keema + Jowar Roti",
                dayOfWeek: 4, mealType: "dinner",
                items: "Chicken keema 200 g (peas + tomato gravy); 2 jowar rotis; sautéed beans.",
                calories: 490, protein: 46, carbs: 42, fat: 14,
                suggestedTime: "20:30"
            ),

            // ───────────────── Day 5 — Friday ─────────────────
            MealTemplate(
                name: "Moong Dal Chilla + Paneer",
                dayOfWeek: 5, mealType: "breakfast",
                items: "3 moong dal chillas stuffed with paneer 80 g; mint chutney.",
                calories: 460, protein: 38, carbs: 40, fat: 14,
                suggestedTime: "08:00"
            ),
            MealTemplate(
                name: "Whey + Banana + Almond Butter",
                dayOfWeek: 5, mealType: "snack",
                items: "Whey shake 30 g; 1 banana; 15 g almond butter on a rice cake.",
                calories: 320, protein: 28, carbs: 32, fat: 10,
                suggestedTime: "11:00"
            ),
            MealTemplate(
                name: "Chicken Curry + Rice + Dal",
                dayOfWeek: 5, mealType: "lunch",
                items: "Chicken curry 200 g; 1.5 cups brown rice; ½ cup dal; cucumber salad.",
                calories: 600, protein: 48, carbs: 70, fat: 12,
                suggestedTime: "13:30"
            ),
            MealTemplate(
                name: "Sprouts Salad + Pistachios",
                dayOfWeek: 5, mealType: "snack",
                items: "Mixed sprouts salad 1 cup with onion, lemon, pomegranate; 25 g pistachios.",
                calories: 270, protein: 16, carbs: 26, fat: 10,
                suggestedTime: "17:00"
            ),
            MealTemplate(
                name: "Grilled Chicken + Roast Veg",
                dayOfWeek: 5, mealType: "dinner",
                items: "Grilled chicken 200 g; roasted veg medley (zucchini, capsicum, beans); 1 small sweet potato.",
                calories: 460, protein: 50, carbs: 38, fat: 12,
                suggestedTime: "20:30"
            ),

            // ───────────────── Day 6 — Saturday ─────────────────
            MealTemplate(
                name: "Boiled Eggs + Brown Bread + PB",
                dayOfWeek: 6, mealType: "breakfast",
                items: "4 boiled eggs; 2 slices brown bread; 30 g peanut butter.",
                calories: 540, protein: 38, carbs: 36, fat: 26,
                suggestedTime: "08:00"
            ),
            MealTemplate(
                name: "Paneer Tikka + Coffee",
                dayOfWeek: 6, mealType: "snack",
                items: "Paneer tikka 100 g (low-oil, air-fried); cucumber sticks; black coffee.",
                calories: 220, protein: 22, carbs: 8, fat: 12,
                suggestedTime: "11:00"
            ),
            MealTemplate(
                name: "Chicken Kebab Roll",
                dayOfWeek: 6, mealType: "lunch",
                items: "2 atta wraps with chicken seekh kebab 200 g, onions, mint chutney; raita; onion salad.",
                calories: 590, protein: 48, carbs: 52, fat: 18,
                suggestedTime: "13:30"
            ),
            MealTemplate(
                name: "Yoghurt + Berries + Whey",
                dayOfWeek: 6, mealType: "snack",
                items: "Greek yoghurt 200 g; berries; ⅔ scoop whey (20 g).",
                calories: 250, protein: 30, carbs: 18, fat: 4,
                suggestedTime: "17:00"
            ),
            MealTemplate(
                name: "Methi Chicken + Roti + Dal",
                dayOfWeek: 6, mealType: "dinner",
                items: "Methi chicken 200 g; 2 multigrain rotis; dal tadka 1 bowl.",
                calories: 480, protein: 46, carbs: 44, fat: 14,
                suggestedTime: "20:30"
            ),

            // ───────────────── Day 7 — Sunday ─────────────────
            MealTemplate(
                name: "Masala Oats + Chicken + Eggs",
                dayOfWeek: 7, mealType: "breakfast",
                items: "Masala oats 50 g cooked with shredded chicken 100 g; 2 boiled eggs on the side.",
                calories: 510, protein: 44, carbs: 42, fat: 16,
                suggestedTime: "08:00"
            ),
            MealTemplate(
                name: "Whey + Apple + Cashews",
                dayOfWeek: 7, mealType: "snack",
                items: "Whey shake 30 g; 1 apple; 25 g cashews.",
                calories: 320, protein: 28, carbs: 32, fat: 12,
                suggestedTime: "11:00"
            ),
            MealTemplate(
                name: "Egg-Paneer Paratha + Curd",
                dayOfWeek: 7, mealType: "lunch",
                items: "2 homemade parathas stuffed with egg + paneer (low oil); 1 cup curd; salad.",
                calories: 590, protein: 42, carbs: 56, fat: 20,
                suggestedTime: "13:30"
            ),
            MealTemplate(
                name: "Roasted Chana + Orange",
                dayOfWeek: 7, mealType: "snack",
                items: "Roasted chana 60 g; 1 orange.",
                calories: 240, protein: 14, carbs: 38, fat: 4,
                suggestedTime: "17:00"
            ),
            MealTemplate(
                name: "Chicken Tikka + Jeera Rice + Kale",
                dayOfWeek: 7, mealType: "dinner",
                items: "Chicken tikka 200 g; ½ cup jeera rice; sautéed kale + garlic; raita.",
                calories: 470, protein: 50, carbs: 36, fat: 12,
                suggestedTime: "20:30"
            ),
        ]
    }
}
