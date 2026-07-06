#' Calculate Nutrients
#' @param file_path Path to the input Excel file
#' @return Processed data frame
#' @export
calculate_nutrients <- function(file_path) {
  xlsx_path <- file_path
df <- readxl::read_excel(xlsx_path, sheet = 1)

head(df)

df[is.na(df)] <- 0

freq_cols <- grep("_Frequency$", names(df), value = TRUE)

df[freq_cols] <- lapply(df[freq_cols], function(x) {
  dplyr::recode(x,
                `0` = 0,
                `1` = 0,
                `2` = 12/365,
                `3` = 7/365,
                `4` = 1,
                .default = x)
})

#第一部分计算吃了多少
df$rice = df$'A1_White_Rice_Dry_Breakfast_Frequency'*df$'4_2；A1.02Times'*df$'4_3；A1.03Amount'+
          df$'4_4；lunch:_A1.04Frequency'*df$'4_5；A1.05Times'*df$'4_6；A1.06Amount'+
          df$'4_7；dinner:_A1.07Frequency'*df$'4_8；A1.08Times'*df$'4_9；A1.09Amount'+
          df$'4_10；Late_night_snack:_A1.10Frequency'*df$'4_11；A1.11Times'*df$'4_12；A1.12Amount'

df$White_Congee = df$'A2_White_Congee_Thin_Breakfast_Frequency'*df$'4_14；A2.02Times'*df$'4_15；A2.03Amount'+
          df$'4_16；lunch:_A2.04Frequency'*df$'4_17；A2.05Times'*df$'4_18；A2.06Amount'+
          df$'4_19；dinner:_A2.07Frequency'*df$'4_20；A2.08Times'*df$'4_21；A2.09Amount'+
          df$'4_22；Late_night_snack:_A2.10Frequency'*df$'4_23；A2.11Times'*df$'4_24；A2.12Amount'

df$Rice_Noodles = df$'A3_Rice_Noodles_Breakfast_Frequency'*df$'4_26；A3.02Times'*df$'4_27；A3.03Amount'+
          df$'4_28；lunch:_A3.04Frequency'*df$'4_29；A3.05Times'*df$'4_30；A3.06Amount'+
          df$'4_31；dinner:_A3.07Frequency'*df$'4_32；A3.08Times'*df$'4_33；A3.09Amount'+
          df$'4_34；Late_night_snack:_A3.10Frequency'*df$'4_35；A3.11Times'*df$'4_36；A3.12Amount'

df$Vermicelli = df$'A4_Vermicelli_Breakfast_Frequency'*df$'4_38；A4.02Times'*df$'4_39；A4.03Amount'+
          df$'4_40；lunch:_A4.04Frequency'*df$'4_41；A4.05Times'*df$'4_42；A4.06Amount'+
          df$'4_43；dinner:_A4.07Frequency'*df$'4_44；A4.08Times'*df$'4_45；A4.09Amount'+
          df$'4_46；Late_night_snack:_A4.10Frequency'*df$'4_47；A4.11Times'*df$'4_48；A4.12Amount'

df$Guobianhu = df$'A5_Guobianhu_Breakfast_Frequency'*df$'4_50；A5.02Times'*df$'4_51；A5.03Amount'+
          df$'4_52；lunch:_A5.04Frequency'*df$'4_53；A5.05Times'*df$'4_54；A5.06Amount'+
          df$'4_55；dinner:_A5.07Frequency'*df$'4_56；A5.08Times'*df$'4_57；A5.09Amount'+
          df$'4_58；Late_night_snack:_A5.10Frequency'*df$'4_59；A5.11Times'*df$'4_60；A5.12Amount'

df$Noodles = df$'A6_Noodles_Breakfast_Frequency'*df$'4_62；A6.02Times'*df$'4_63；A6.03Amount'+
          df$'4_64；lunch:_A6.04Frequency'*df$'4_65；A6.05Times'*df$'4_66；A6.06Amount'+
          df$'4_67；dinner:_A6.07Frequency'*df$'4_68；A6.08Times'*df$'4_69；A6.09Amount'+
          df$'4_70；Late_night_snack:_A6.10Frequency'*df$'4_71；A6.11Times'*df$'4_72；A6.12Amount'

df$Instant_Noodles = df$'A7_Instant_Noodles_Breakfast_Frequency'*df$'4_74；A7.02Times'*df$'4_75；A7.03Amount'+
          df$'4_76；lunch:_A7.04Frequency'*df$'4_77；A7.05Times'*df$'4_78；A7.06Amount'+
          df$'4_79；dinner:_A7.07Frequency'*df$'4_80；A7.08Times'*df$'4_81；A7.09Amount'+
          df$'4_82；Late_night_snack:_A7.10Frequency'*df$'4_83；A7.11Times'*df$'4_84；A7.12Amount'

df$Macaroni_Pasta = df$'A8_Macaroni_Pasta_Breakfast_Frequency'*df$'4_86；A8.02Times'*df$'4_87；A8.03Amount'+
          df$'4_88；lunch:_A8.04Frequency'*df$'4_89；A8.05Times'*df$'4_90；A8.06Amount'+
          df$'4_91；dinner:_A8.07Frequency'*df$'4_92；A8.08Times'*df$'4_93；A8.09Amount'+
          df$'4_94；Late_night_snack:_A8.10Frequency'*df$'4_95；A8.11Times'*df$'4_96；A8.12Amount'          

df$White_Steamed_Bread = df$'A9_White_Steamed_Bread_Breakfast_Frequency'*df$'4_98；A9.02Times'*df$'4_99；A9.03Amount'+
          df$'4_100；lunch:_A9.04Frequency'*df$'4_101；A9.05Times'*df$'4_102；A9.06Amount'+
          df$'4_103；dinner:_A9.07Frequency'*df$'4_104；A9.08Times'*df$'4_105；A9.09Amount'+
          df$'4_106；Late_night_snack:_A9.10Frequency'*df$'4_107；A9.11Times'*df$'4_108；A9.12Amount'

df$Oatmeal = df$'A10_Oatmeal_Breakfast_Frequency'*df$'4_110；A10.02Times'*df$'4_111；A10.03Amount'+
          df$'4_112；lunch:_A10.04Frequency'*df$'4_113；A10.05Times'*df$'4_114；A10.06Amount'+
          df$'4_115；dinner:_A10.07Frequency'*df$'4_116；A10.08Times'*df$'4_117；A10.09Amount'+
          df$'4_118；Late_night_snack:_A10.10Frequency'*df$'4_119；A10.11Times'*df$'4_120；A10.12Amount'

df$Pork_Buns = df$'A11_Pork_Buns_Breakfast_Frequency'*df$'4_122；A11.02Times'*df$'4_123；A11.03Amount'+
          df$'4_124；lunch:_A11.04Frequency'*df$'4_125；A11.05Times'*df$'4_126；A11.06Amount'+
          df$'4_127；dinner:_A11.07Frequency'*df$'4_128；A11.08Times'*df$'4_129；A11.09Amount'+
          df$'4_130；Late_night_snack:_A11.10Frequency'*df$'4_131；A11.11Times'*df$'4_132；A11.12Amount'

df$Dumplings_Pork_Mushroom = df$'A12_Dumplings_Pork_Mushroom_Breakfast_Frequency'*df$'4_134；A12.02Times'*df$'4_135；A12.03Amount'+
          df$'4_136；lunch:_A12.04Frequency'*df$'4_137；A12.05Times'*df$'4_138；A12.06Amount'+
          df$'4_139；dinner:_A12.07Frequency'*df$'4_140；A12.08Times'*df$'4_141；A12.09Amount'+
          df$'4_142；Late_night_snack:_A12.10Frequency'*df$'4_143；A12.11Times'*df$'4_144；A12.12Amount'

df$Dumplings_Pork_Chive = df$'A13_Dumplings_Pork_Chive_Breakfast_Frequency'*df$'4_146；A13.02Times'*df$'4_147；A13.03Amount'+
          df$'4_148；lunch:_A13.04Frequency'*df$'4_149；A13.05Times'*df$'4_150；A13.06Amount'+
          df$'4_151；dinner:_A13.07Frequency'*df$'4_152；A13.08Times'*df$'4_153；A13.09Amount'+
          df$'4_154；Late_night_snack:_A13.10Frequency'*df$'4_155；A13.11Times'*df$'4_156；A13.12Amount'

df$Dumplings_Pork_Cabbage = df$'A14_Dumplings_Pork_Cabbage_Breakfast_Frequency'*df$'4_158；A14.02Times'*df$'4_159；A14.03Amount'+
          df$'4_160；lunch:_A14.04Frequency'*df$'4_161；A14.05Times'*df$'4_162；A14.06Amount'+
          df$'4_163；dinner:_A14.07Frequency'*df$'4_164；A14.08Times'*df$'4_165；A14.09Amount'+
          df$'4_166；Late_night_snack:_A14.10Frequency'*df$'4_167；A14.11Times'*df$'4_168；A14.12Amount'

df$Dumplings_Three_Fresh = df$'A15_Dumplings_Three_Fresh_Breakfast_Frequency'*df$'4_170；A15.02Times'*df$'4_171；A15.03Amount'+
          df$'4_172；lunch:_A15.04Frequency'*df$'4_173；A15.05Times'*df$'4_174；A15.06Amount'+
          df$'4_175；dinner:_A15.07Frequency'*df$'4_176；A15.08Times'*df$'4_177；A15.09Amount'+
          df$'4_178；Late_night_snack:_A15.10Frequency'*df$'4_179；A15.11Times'*df$'4_180；A15.12Amount'

df$Bread = df$'A16_Bread_Breakfast_Frequency'*df$'4_182；A16.02Times'*df$'4_183；A16.03Amount'+
          df$'4_184；lunch:_A16.04Frequency'*df$'4_185；A16.05Times'*df$'4_186；A16.06Amount'+
          df$'4_187；dinner:_A16.07Frequency'*df$'4_188；A16.08Times'*df$'4_189；A16.09Amount'+
          df$'4_190；Late_night_snack:_A16.10Frequency'*df$'4_191；A16.11Times'*df$'4_192；A16.12Amount'

df$Oil_Cake = df$'A17_Oil_Cake_Breakfast_Frequency'*df$'4_194；A17.02Times'*df$'4_195；A17.03Amount'+
          df$'4_196；_lunch:_A17.04Frequency'*df$'4_197；A17.05Times'*df$'4_198；A17.06Amount'+
          df$'4_199；_dinner:_A17.07Frequency'*df$'4_200；A17.08Times'*df$'4_201；A17.09Amount'+
          df$'4_202；_Late_night_snack:_A17.10Frequency'*df$'4_203；A17.11Times'*df$'4_204；A17.12Amount'

df$Deep_fried_dough_sticks = df$'4_205；_A18_Deep_fried_dough_sticks_for_breakfast:_A18.01Frequency'*df$'4_206；A18.02Times'*df$'4_207；A18.03Amount'+
          df$'4_208；_lunch:_A18.04Frequency'*df$'4_209；A18.05Times'*df$'4_210；A18.06Amount'+
          df$'4_211；_dinner:_A18.07Frequency'*df$'4_212；A18.08Times'*df$'4_213；A18.09Amount'+
          df$'4_214；_Late_night_snack:_A18.10Frequency'*df$'4_215；A18.11Times'*df$'4_216；A18.12Amount'

df$Fried_Cake = df$'A19_Fried_Cake_Breakfast_Frequency'*df$'4_218；A19.02Times'*df$'4_219；A19.03Amount'+
          df$'4_220；_lunch:_A19.04Frequency'*df$'4_221；A19.05Times'*df$'4_222；A19.06Amount'+
          df$'4_223；_dinner:_A19.07Frequency'*df$'4_224；A19.08Times'*df$'4_225；A19.09Amount'+
          df$'4_226；_Late_night_snack:_A19.10Frequency'*df$'4_227；A19.11Times'*df$'4_228；A19.12Amount'

df$Baked_Cake = df$'A20_Baked_Cake_Breakfast_Frequency'*df$'4_230；A20.02Times'*df$'4_231；A20.03Amount'+
          df$'4_232；_lunch:_A20.04Frequency'*df$'4_233；A20.05Times'*df$'4_234；A20.06Amount'+
          df$'4_235；_dinner:_A20.07Frequency'*df$'4_236；A20.08Times'*df$'4_237；A20.09Amount'+
          df$'4_238；_Late_night_snack:_A20.10Frequency'*df$'4_239；A20.11Times'*df$'4_240；A20.12Amount'

df$Bianrou = df$'A21_Bianrou_Breakfast_Frequency'*df$'4_242；A21.02Times'*df$'4_243；A21.03Amount'+
          df$'4_244；_lunch:_A21.04Frequency'*df$'4_245；A21.05Times'*df$'4_246；A21.06Amount'+
          df$'4_247；_dinner:_A21.07Frequency'*df$'4_248；A21.08Times'*df$'4_249；A21.09Amount'+
          df$'4_250；_Late_night_snack:_A21.10Frequency'*df$'4_251；A21.11Times'*df$'4_252；A21.12Amount'

df$Rouyan = df$'A22_Rouyan_Breakfast_Frequency'*df$'4_254；A22.02Times'*df$'4_255；A22.03Amount'+
          df$'4_256；_lunch:_A22.04Frequency'*df$'4_257；A22.05Times'*df$'4_258；A22.06Amount'+
          df$'4_259；_dinner:_A22.07Frequency'*df$'4_260；A22.08Times'*df$'4_261；A22.09Amount'+
          df$'4_262；_Late_night_snack:_A22.10Frequency'*df$'4_263；A22.11Times'*df$'4_264；A22.12Amount'

df$Fish_balls = df$'4_265；23_Fish_balls_for_breakfast:_A23.01Frequency'*df$'4_266；A23.02Times'*df$'4_267；A23.03Amount'+
          df$'4_268；_lunch:_A23.04Frequency'*df$'4_269；A23.05Times'*df$'4_270；A23.06Amount'+
          df$'4_271；_dinner:_A23.07Frequency'*df$'4_272；A23.08Times'*df$'4_273；A23.09Amount'+
          df$'4_274；_Late_night_snack:_A23.10Frequency'*df$'4_275；A23.11Times'*df$'4_276；A23.12Amount'

df$Cuttlefish_Balls = df$'A24_Cuttlefish_Balls_Breakfast_Frequency'*df$'4_278；A24.02Times'*df$'4_279；A24.03Amount'+
          df$'4_280；_lunch:_A24.04Frequency'*df$'4_281；A24.05Times'*df$'4_282；A24.06Amount'+
          df$'4_283；_dinner:_A24.07Frequency'*df$'4_284；A24.08Times'*df$'4_285；A24.09Amount'+
          df$'4_286；_Late_night_snack:_A24.10Frequency'*df$'4_287；A24.11Times'*df$'4_288；A24.12Amount'

df$Sweet_Potato = df$'B1_Sweet_Potato_Frequency'*df$'5_2；B1.02Times'

df$Taro = df$'B2_Taro_Frequency'*df$'5_4；B2.02Times'

df$Potato = df$'B3_Potato_Frequency'*df$'5_6；B3.02Times'

df$Jicama = df$'B4_Jicama_Frequency'*df$'5_8；B4.02Times；'

df$Salted_Duck_Egg = df$'C1_Salted_Duck_Egg_Frequency'*df$'6_2；C1.02Times'

df$Century_Egg = df$'C2_Century_Egg_Frequency'*df$'6_4；C2.02Times'

df$Pickled_Vegetables = df$'C3_Pickled_Vegetables_Frequency'*df$'6_6；C3.02Times'

df$Fermented_Bean_Curd = df$'C4_Fermented_Bean_Curd_Frequency'*df$'6_8；C4.02Times'

df$Bean_Paste = df$'C5_Bean_Paste_Frequency'*df$'6_10；C5.02Times'

df$Pork_Floss = df$'C6_Pork_Floss_Frequency'*df$'6_12；C6.02Times'

df$Ham_Sausage = df$'C7_Ham_Sausage_Frequency'*df$'6_14；C7.02Times'

df$Chicken_Egg = df$'D1_Chicken_Egg_Frequency'*df$'7_2；D1.02Times'

df$Duck_Egg = df$'D2_Duck_Egg_Frequency'*df$'7_4；D2.02Times'

df$Pork = df$'E1_Pork_Frequency'*df$'8_2；E1.02Times'

df$Pork_Chops = df$'E2_Pork_Chops_Frequency'*df$'8_4；E2.02Times'

df$Beef = df$'E3_Beef_Frequency'*df$'8_6；E3.02Times'

df$Mutton = df$'E4_Mutton_Frequency'*df$'8_8；E4.02Times'

df$Rabbit_Meat = df$'E5_Rabbit_Meat_Frequency'*df$'8_10；E5.02Times'

df$Chicken = df$'E6_Chicken_Frequency'*df$'8_12；E6.02Times'

df$Duck = df$'E7_Duck_Frequency'*df$'8_14；E7.02Times'

df$Pork_Tripe = df$'E8_Pork_Tripe_Frequency'*df$'8_16；E8.02Times'

df$Pork_Liver = df$'E9_Pork_Liver_Frequency'*df$'8_18；E9.02Times'

df$Pork_Trotters = df$'E10_Pork_Trotters_Frequency'*df$'8_20；E10.02Times'

df$Pork_Blood = df$'E11_Pork_Blood_Frequency'*df$'8_22；E11.02Times'

df$Chicken_Gizzard = df$'E12_Chicken_Gizzard_Frequency'*df$'8_24；E12.02Times'

df$Chicken_Wings = df$'E13_Chicken_Wings_Frequency'*df$'8_26；E13.02Times'

df$Chicken_Feet = df$'E14_Chicken_Feet_Frequency'*df$'8_28；E14.02Times'

df$Grass_Carp = df$'H1_Grass_Carp_Frequency'*df$'9_2；H1.02Times'

df$Silver_Carp = df$'H2_Silver_Carp_Frequency'*df$'9_4；H2.02Times'

df$Crucian_Carp = df$'H3_Crucian_Carp_Frequency'*df$'9_6；H3.02Times'

df$Perch = df$'H4_Perch_Frequency'*df$'9_8；H4.02Times'

df$Yellow_Croaker = df$'H5_Yellow_Croaker_Frequency'*df$'9_10；H5.02Times'

df$Eel = df$'H6_Eel_Frequency'*df$'9_12；H6.02Times'

df$Sardine = df$'H7_Sardine_Frequency'*df$'9_14；H7.02Times'

df$Black_Carp = df$'H8_Black_Carp_Frequency'*df$'9_16；H8.02Times'

df$Mackerel = df$'H9_Mackerel_Frequency'*df$'9_18；H9.02Times'

df$Spanish_Mackerel = df$'H10_Spanish_Mackerel_Frequency'*df$'9_20；H10.02Times'

df$Pomfret = df$'H11_Pomfret_Frequency'*df$'9_22；H11.02Times'

df$Hairtail = df$'H12_Hairtail_Frequency'*df$'9_24；H12.02Times'

df$Mandarin_Fish = df$'H13_Mandarin_Fish_Frequency'*df$'9_26；H13.02Times'

df$Dike_Fish = df$'H14_Dike_Fish_Frequency'*df$'9_28；H14.02Times'

df$Bream = df$'H15_Bream_Frequency'*df$'9_30；H15.02Times'

df$Horse_Mackerel = df$'H16_Horse_Mackerel_Frequency'*df$'9_32；H16.02Times'

df$Flatfish = df$'H17_Flatfish_Frequency'*df$'9_34；H17.02Times'

df$Rice_Eel = df$'H18_Rice_Eel_Frequency'*df$'9_36；H18.02Times'

df$Squid = df$'H19_Squid_Frequency'*df$'9_38；H19.02Times'

df$Octopus = df$'H20_Octopus_Frequency'*df$'9_40；H20.02Times'

df$Crab = df$'H21_Crab_Frequency'*df$'9_42；H21.02Times'

df$Sea_Shrimp = df$'H22_Sea_Shrimp_Frequency'*df$'9_44；H22.02Times'

df$Snail = df$'H23_Snail_Frequency'*df$'9_46；H23.02Times'

df$Clam = df$'H24_Clam_Frequency'*df$'9_48；H24.02Times'

df$Oyster = df$'H25_Oyster_Frequency'*df$'9_50；H25.02Times'

df$Razor_Clam = df$'H26_Razor_Clam_Frequency'*df$'9_52；H26.02Times'

df$Mussel = df$'H27_Mussel_Frequency'*df$'9_54；H27.02Times'

df$Jellyfish = df$'H28_Jellyfish_Frequency'*df$'9_56；H28.02Times'

df$Fresh_Milk_Boxed_Milk = df$'I1_Fresh_Milk_Boxed_Milk_Frequency'*df$'10_2；I1.02Times'

df$Milk_Powder = df$'I2_Milk_Powder_Frequency'*df$'10_4；I2.02Times'

df$Yogurt = df$'I3_Yogurt_Frequency'*df$'10_6；I3.02Times'

df$Soy_Milk = df$'I4_Soy_Milk_Frequency'*df$'10_8；I4.02Times'

df$Breakfast_Milk_Breakfast_Drink = df$'I5_Breakfast_Milk_Breakfast_Frequency'*df$'10_10；I5.02Times'

df$Cake = df$'J1_Cake_Frequency'*df$'11_2；J1.02Times'

df$Peanuts = df$'J2_Peanuts_Frequency'*df$'11_4；J2.02Times'

df$Other_Nuts = df$'J3_Other_Nuts_Frequency'*df$'11_6；J3.02Times'

df$Sweetened_Drinks = df$'K1_Sweetened_Drinks_Frequency'*df$'12_2；K1.02Times'

df$Sugar_Free_Drinks = df$'K2_Sugar_Free_Drinks_Frequency'*df$'12_4；K2.02Times'

df$Coffee = df$'K3_Coffee_Frequency'*df$'12_6；K3.02Times'

df$Carbonated_Drinks = df$'K4_Carbonated_Drinks_Frequency'*df$'12_8；K4.02Times；'

df$Soybeans = df$'L1_Soybeans_Frequency'*df$'13_2；L1.02Times'

df$Mung_Beans = df$'L2_Mung_Beans_Frequency'*df$'13_4；L2.02Times'

df$Soybean_Milk = df$'L3_Soy_Milk_Frequency'*df$'13_6；L3.02Times'

df$Tofu = df$'L4_Tofu_Frequency'*df$'13_8；L4.02Times'

df$Dried_Tofu  = df$'L5_Dried_Tofu_Frequency'*df$'13_10；L5.02Times'

df$Tofu_Skin = df$'L6_Tofu_Skin_Frequency'*df$'13_12；L6.02Times'

df$Tofu_Strips = df$'L7_Tofu_Strips_Frequency'*df$'13_14；L7.02Times'

df$Fried_Tofu = df$'L8_Fried_Tofu_Frequency'*df$'13_16；L8.02Times'

df$Soybean_Sprouts = df$'L9_Soybean_Sprouts_Frequency'*df$'13_18；L9.02Times'

df$Mung_Bean_Sprouts = df$'L10_Mung_Bean_Sprouts_Frequency'*df$'13_20；L10.02Times'

df$Green_Beans = df$'M1_Green_Beans_Frequency'*df$'14_2；M1.02Times'

df$Snow_Peas = df$'M2_Snow_Peas_Frequency'*df$'14_4；M2.02Times'

df$String_Beans = df$'M3_String_Beans_Frequency'*df$'14_6；M3.02Times'

df$White_Radish_Leaves = df$'M4_White_Radish_Leaves_Frequency'*df$'14_8；M4.02Times'

df$Carrot_Leaves = df$'M5_Carrot_Leaves_Frequency'*df$'14_10；M5.02Times'

df$Carrot = df$'M6_Carrot_Frequency'*df$'14_12；M6.02Times'

df$White_Radish = df$'M7_White_Radish_Frequency'*df$'14_14；M7.02Times'

df$Lotus_Root = df$'M8_Lotus_Root_Frequency'*df$'14_16；M8.02Times'

df$Bamboo_Shoots  = df$'M9_Bamboo_Shoots_Frequency'*df$'14_18；M9.02Times'

df$Cauliflower = df$'M10_Cauliflower_Frequency'*df$'14_20；M10.02Times'

df$Baby_Bok_Choy = df$'M11_Baby_Bok_Choy_Frequency'*df$'14_22；M11.02Times'

df$Bokchoy = df$'M12_Bokchoy_Frequency'*df$'14_24；M12.02Times'

df$Chinese_Cabbage = df$'M13_Chinese_Cabbage_Frequency'*df$'14_26；M13.02Times'

df$Onion = df$'M14_Onion_Frequency'*df$'14_28；M14.02Times'

df$Garlic = df$'M15_Garlic_Frequency'*df$'14_30；M15.02Times'

df$Water_Bamboo = df$'M16_Water_Bamboo_Frequency'*df$'14_32；M16.02Times'

df$Amaranth = df$'M17_Amaranth_Frequency'*df$'14_34；M17.02Times'

df$Cabbage = df$'M18_Cabbage_Frequency'*df$'14_36；M18.02Times'

df$Chinese_Chives = df$'M19_Chinese_Chives_Frequency'*df$'14_38；M19.02Times'

df$Water_Spinach = df$'M20_Water_Spinach_Frequency'*df$'14_40；M20.02Times'

df$Spinach = df$'M21_Spinach_Frequency'*df$'14_42；M21.02Times'

df$Mustard_Greens = df$'M22_Mustard_Greens_Frequency'*df$'14_44；M22.02Times'

df$Turnip = df$'M23_Turnip_Frequency'*df$'14_46；M23.02Times'

df$Chinese_Broccoli = df$'M24_Chinese_Broccoli_Frequency'*df$'14_48；M24.02Times'

df$Shepherds_Purse = df$'M25_Shepherds_Purse_Frequency'*df$'14_50；M25.02Times'

df$Celery = df$'M26_Celery_Frequency'*df$'14_52；M26.02Times'

df$Rapeseed = df$'M27_Rapeseed_Frequency'*df$'14_54；M27.02Times'

df$Lettuce = df$'M28_Lettuce_Frequency'*df$'14_56；M28.02Times'

df$Winter_Melon = df$'M29_Winter_Melon_Frequency'*df$'14_58；M29.02Times'

df$Cucumber = df$'M30_Cucumber_Frequency'*df$'14_60；M30.02Times'

df$Luffa = df$'M31_Luffa_Frequency'*df$'14_62；M31.02Times'

df$Bitter_Melon = df$'M32_Bitter_Melon_Frequency'*df$'14_64；M32.02Times'

df$Pumpkin = df$'M33_Pumpkin_Frequency'*df$'14_66；M33.02Times'

df$Chayote = df$'M34_Chayote_Frequency'*df$'14_68；M34.02Times'

df$Tomato = df$'M35_Tomato_Frequency'*df$'14_70；M35.02Times'

df$Chili_Pepper = df$'M36_Chili_Pepper_Frequency'*df$'14_72；M36.02Times'

df$Eggplant = df$'M37_Eggplant_Frequency'*df$'14_74；M37.02Times'

df$Green_Pepper = df$'M38_Green_Pepper_Frequency'*df$'14_76；M38.02Times'

df$Wood_Ear_Mushroom = df$'M39_Wood_Ear_Mushroom_Frequency'*df$'14_78；M39.02Times'

df$Enoki_Mushroom = df$'M40_Enoki_Mushroom_Frequency'*df$'14_80；M40.02Times'

df$Mushroom = df$'M41_Mushroom_Frequency'*df$'14_82；M41.02Times'

df$Shiitake_Mushroom = df$'M42_Shiitake_Mushroom_Frequency'*df$'14_84；M42.02Times'

df$Scallion = df$'M43_Scallion_Frequency'*df$'14_86；M43.02Times'

df$Kelp = df$'M44_Kelp_Frequency'*df$'14_88；M44.02Times'

df$Apple = df$'N1_Apple_Frequency'*df$'15_2；N1.02Times'

df$Banana = df$'N2_Banana_Frequency'*df$'15_4；N2.02Times'

df$Orange = df$'N3_Orange_Frequency'*df$'15_6；N3.02Times'

df$Pomelo = df$'N4_Pomelo_Frequency'*df$'15_8；N4.02Times'

df$Pear = df$'N5_Pear_Frequency'*df$'15_10；N5.02Times'

df$Peach = df$'N6_Peach_Frequency'*df$'15_12；N6.02Times'

df$Mango = df$'N7_Mango_Frequency'*df$'15_14；N7.02Times'

df$Pineapple = df$'N8_Pineapple_Frequency'*df$'15_16；N8.02Times'

df$Muskmelon = df$'N9_Muskmelon_Frequency'*df$'15_18；N9.02Times'

df$Grape = df$'N10_Grape_Frequency'*df$'15_20；N10.02Times'

df$Persimmon = df$'N11_Persimmon_Frequency'*df$'15_22；N11.02Times'

df$Longan = df$'N12_Longan_Frequency'*df$'15_24；N12.02Times'

df$Lychee = df$'N13_Lychee_Frequency'*df$'15_26；N13.02Times'

df$Loquat = df$'N14_Loquat_Frequency'*df$'15_28；N14.02Times'

df$Watermelon = df$'N15_Watermelon_Frequency'*df$'15_30；N15.02Times'

df$Strawberry = df$'N16_Strawberry_Frequency'*df$'15_32；N16.02Times'

df$Kiwi = df$'N17_Kiwi_Frequency'*df$'15_34；N17.02Times'

df$Dragon_Fruit = df$'N18_Dragon_Fruit_Frequency'*df$'15_36；N18.02Times'

df$Water_Chestnut = df$'N19_Water_Chestnut_Frequency'*df$'15_38；N19.02Times'

df$Dried_Shiitake = df$'O1_Dried_Shiitake_Frequency'*df$'16_2；O1.02Times'

df$Dried_Kelp = df$'O2_Dried_Kelp_Frequency'*df$'16_4；O2.02Times'

df$Dried_Seaweed = df$'O3_Dried_Seaweed_Frequency'*df$'16_6；O3.02Times'

df$Dried_Scallop = df$'O4_Dried_Scallop_Frequency'*df$'16_8；O4.02Times'

df$Dried_Fish = df$'O5_Dried_Fish_Frequency'*df$'16_10；O5.02Times'

#第二部分先算宏量营养素
df$water = (70.9*df$rice+88.6*df$White_Congee+12.7*df$Rice_Noodles+15*df$Vermicelli+29.7*df$Noodles
         + 11.8*df$Macaroni_Pasta+40.3*df$White_Steamed_Bread +10.2*df$Oatmeal+24.8*df$Oil_Cake
         +21.8*df$Deep_fried_dough_sticks+25.9*df$Baked_Cake+72.5*df$Fish_balls+71*df$Cuttlefish_Balls
         +0.86*72.6*df$Sweet_Potato+83*df$Taro+0.94*78.6*df$Potato+0.91*85.2*df$Jicama+0.84*70*df$Salted_Duck_Egg
         +0.9*68.4*df$Century_Egg+3.6*df$Pork_Floss+56.2*df$Ham_Sausage+0.87*75.2*df$Chicken_Egg+0.87*70.3*df$Duck_Egg
         +0.91*54.9*df$Pork+0.69*59.4*df$Pork_Chops+69.8*df$Beef+72.5*df$Mutton+0.63*70.5*df$Chicken
         +0.68*63.9*df$Duck+0.96*78.2*df$Pork_Tripe+72.6*df$Pork_Liver+0.6*58.2*df$Pork_Trotters
         +85.8*df$Pork_Blood+73.1*df$Chicken_Gizzard+0.69*63.3*df$Chicken_Wings+0.6*56.4*df$Chicken_Feet
         +0.58*77.3*df$Grass_Carp+0.61*77.4*df$Silver_Carp+0.54*75.4*df$Crucian_Carp+0.58*76.5*df$Perch
         +0.64*78.55*df$Yellow_Croaker+0.54*67.1*df$Eel+0.67*78*df$Sardine+0.63*73.9*df$Black_Carp 
         +0.49*45.2*df$Mackerel+0.72*64.4*df$Spanish_Mackerel+0.7*72.8*df$Pomfret+0.76*73.3*df$Hairtail
         +0.61*74.5*df$Mandarin_Fish+0.64*66.9*df$Dike_Fish+0.59*73.1*df$Bream+0.7*72*df$Horse_Mackerel
         +0.67*78*df$Rice_Eel+0.97*80.4*df$Squid+86.4*df$Octopus+84.4*df$Crab+0.59*73.6*df$Sea_Shrimp
         +0.41*73.6*df$Snail+0.39*84.1*df$Clam+82*df$Oyster+0.57*88.4*df$Razor_Clam+0.49*79.9*df$Mussel
         +72.75*df$Jellyfish+87.1*df$Fresh_Milk_Boxed_Milk+2.6*df$Milk_Powder+81*df$Yogurt+94*df$Soy_Milk
         +85.7*df$Breakfast_Milk_Breakfast_Drink+0.53*48.3*df$Peanuts+0.745*15.7*df$Other_Nuts+9.9*df$Soybeans
         +12.3*df$Mung_Beans+98.3*df$Soybean_Milk+83.8*df$Tofu+61.3*df$Dried_Tofu+9.4*df$Tofu_Skin+58.4*df$Tofu_Strips
         +58.8*df$Fried_Tofu+88.8*df$Soybean_Sprouts+95.3*df$Mung_Bean_Sprouts+0.96*90*df$Green_Beans 
         +0.88*91.9*df$Snow_Peas+0.96*91.3*df$String_Beans+0.95*94.6*df$White_Radish+82.2*df$Carrot_Leaves
         +0.96*89.2*df$Carrot+90.7*df$White_Radish_Leaves+0.88*86.4*df$Lotus_Root+0.63*92.8*df$Bamboo_Shoots
         +0.82*93.2*df$Cauliflower+92.6*df$Baby_Bok_Choy+0.94*94.8*df$Bokchoy+0.89*94.4*df$Chinese_Cabbage
         +0.9*89.2*df$Onion+0.85*66.6*df$Garlic+0.12*95*df$Water_Bamboo+0.74*90.2*df$Amaranth+0.86*94.5*df$Cabbage
         +0.9*92*df$Chinese_Chives+92.3*df$Water_Spinach+0.89*91.2*df$Spinach+0.94*91.5*df$Mustard_Greens+0.83*89.6*df$Turnip
         +0.98*91.0*df$Chinese_Broccoli+0.88*90.6*df$Shepherds_Purse+0.67*93.1*df$Celery+0.96*94.1*df$Rapeseed
         +0.94*96.7*df$Lettuce+0.8*96.9*df$Winter_Melon+0.92*95.8*df$Cucumber+0.83*94.1*df$Luffa
         +0.81*93.4*df$Bitter_Melon+0.85*93.5*df$Pumpkin+94.3*df$Chayote+93.5*df$Tomato+0.8*88.8*df$Chili_Pepper
         +0.95*93.4*df$Eggplant+0.91*93.4*df$Green_Pepper+91.8*df$Wood_Ear_Mushroom+90.2*df$Enoki_Mushroom
         +0.99*92.4*df$Mushroom+91.7*df$Shiitake_Mushroom+0.89*91.1*df$Scallion+94.4*df$Kelp
         +0.85*86.1*df$Apple+0.7*77.1*df$Banana+0.74*87.4*df$Orange+0.69*89*df$Pomelo+0.82*85.9*df$Pear
         +0.89*88.9*df$Peach+0.6*90.6*df$Mango+0.68*88.4*df$Pineapple+0.78*92.9*df$Muskmelon+0.86*88.5*df$Grape
         +0.92*57.2*df$Persimmon+0.5*81.4*df$Longan+0.73*81.9*df$Lychee+0.62*89.3*df$Loquat+0.59*92.3*df$Watermelon
         +0.97*91.3*df$Strawberry+0.83*83.4*df$Kiwi+0.69*84.8*df$Dragon_Fruit+0.78*83.6*df$Water_Chestnut
         +0.95*12.3*df$Dried_Shiitake+0.98*70.5*df$Dried_Kelp+12.7*df$Dried_Seaweed+27.4*df$Dried_Scallop+20.2*df$Dried_Fish
         +(0.45*40.3*df$White_Steamed_Bread+0.35**0.91*54.9*df$Pork+0.89*91.1*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*54.9*df$Pork+0.35*40.3*df$White_Steamed_Bread+0.89*91.1*0.05*df$Scallion+91.7*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*54.9*df$Pork+0.35*40.3*df$White_Steamed_Bread+0.9*92*0.15*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*54.9*df$Pork+0.35*40.3*df$White_Steamed_Bread+0.89*94.4*0.15*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*54.9*df$Pork+0.35*40.3*df$White_Steamed_Bread+0.9*92*0.1*df$Chinese_Chives+0.1*0.59*73.6*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)

df$energy = (116*df$rice+46*df$White_Congee+349*df$Rice_Noodles+338*df$Vermicelli+283*df$Noodles
         + 351*df$Macaroni_Pasta+235*df$White_Steamed_Bread +338*df$Oatmeal+403*df$Oil_Cake
         +338*df$Deep_fried_dough_sticks+298*df$Baked_Cake+107*df$Fish_balls+128*df$Cuttlefish_Balls
         +0.86*106*df$Sweet_Potato+60*df$Taro+0.94*81*df$Potato+0.91*56*df$Jicama+0.84*177*df$Salted_Duck_Egg
         +0.9*171*df$Century_Egg+493*df$Pork_Floss+280*df$Ham_Sausage+0.87*139*df$Chicken_Egg+0.87*180*df$Duck_Egg
         +0.91*331*df$Pork+0.69*297.5*df$Pork_Chops+160*df$Beef+139*df$Mutton+0.63*145*df$Chicken
         +0.68*240*df$Duck+0.96*110*df$Pork_Tripe+126*df$Pork_Liver+0.6*260*df$Pork_Trotters
         +55*df$Pork_Blood+118*df$Chicken_Gizzard+0.69*202*df$Chicken_Wings+0.6*254*df$Chicken_Feet
         +0.58*113*df$Grass_Carp+0.61*104*df$Silver_Carp+0.54*108*df$Crucian_Carp+0.58*105*df$Perch
         +0.64*105.5*df$Yellow_Croaker+0.54*181*df$Eel+0.67*89*df$Sardine+0.63*118*df$Black_Carp 
         +0.49*413*df$Mackerel+0.72*194*df$Spanish_Mackerel+0.7*140*df$Pomfret+0.76*127*df$Hairtail
         +0.61*117*df$Mandarin_Fish+0.64*191*df$Dike_Fish+0.59*135*df$Bream+0.7*124*df$Horse_Mackerel
         +0.67*89*df$Rice_Eel+0.97*84*df$Squid+52*df$Octopus+62*df$Crab+0.59*103*df$Sea_Shrimp
         +0.41*100*df$Snail+0.39*62*df$Clam+73*df$Oyster+0.57*40*df$Razor_Clam+0.49*80*df$Mussel
         +53.5*df$Jellyfish+67*df$Fresh_Milk_Boxed_Milk+482*df$Milk_Powder+86*df$Yogurt+30*df$Soy_Milk
         +71*df$Breakfast_Milk_Breakfast_Drink+0.53*313*df$Peanuts+0.745*491.3*df$Other_Nuts+396.3*df$Soybeans
         +329*df$Mung_Beans+31*df$Soybean_Milk+84*df$Tofu+197*df$Dried_Tofu+447*df$Tofu_Skin+203*df$Tofu_Strips
         +245*df$Fried_Tofu+47*df$Soybean_Sprouts+16*df$Mung_Bean_Sprouts+0.96*34*df$Green_Beans 
         +0.88*30*df$Snow_Peas+0.96*31*df$String_Beans+0.95*16*df$White_Radish+48*df$Carrot_Leaves
         +0.96*39*df$Carrot+17*df$White_Radish_Leaves+0.88*47*df$Lotus_Root+0.63*23*df$Bamboo_Shoots
         +0.82*20*df$Cauliflower+21*df$Baby_Bok_Choy+0.94*14*df$Bokchoy+0.89*20*df$Chinese_Cabbage
         +0.9*40*df$Onion+0.85*128*df$Garlic+0.12*14*df$Water_Bamboo+0.74*30*df$Amaranth+0.86*17*df$Cabbage
         +0.9*25*df$Chinese_Chives+19*df$Water_Spinach+0.89*28*df$Spinach+0.94*27*df$Mustard_Greens+0.83*36*df$Turnip
         +0.98*24*df$Chinese_Broccoli+0.88*31*df$Shepherds_Purse+0.67*22*df$Celery+0.96*19*df$Rapeseed
         +0.94*12*df$Lettuce+0.8*10*df$Winter_Melon+0.92*16*df$Cucumber+0.83*20*df$Luffa
         +0.81*22*df$Bitter_Melon+0.85*23*df$Pumpkin+18*df$Chayote+22*df$Tomato+0.8*38*df$Chili_Pepper
         +0.95*18*df$Eggplant+0.91*22*df$Green_Pepper+27*df$Wood_Ear_Mushroom+32*df$Enoki_Mushroom
         +0.99*24*df$Mushroom+26*df$Shiitake_Mushroom+0.89*28*df$Scallion+13*df$Kelp
         +0.85*53*df$Apple+0.7*86*df$Banana+0.74*48*df$Orange+0.69*42*df$Pomelo+0.82*51*df$Pear
         +0.89*42*df$Peach+0.6*35*df$Mango+0.68*44*df$Pineapple+0.78*26*df$Muskmelon+0.86*45*df$Grape
         +0.92*164.5*df$Persimmon+0.5*71*df$Longan+0.73*71*df$Lychee+0.62*41*df$Loquat+0.59*31*df$Watermelon
         +0.97*32*df$Strawberry+0.83*61*df$Kiwi+0.69*55*df$Dragon_Fruit+0.78*61*df$Water_Chestnut
         +0.95*274*df$Dried_Shiitake+0.98*90*df$Dried_Kelp+250*df$Dried_Seaweed+264*df$Dried_Scallop+303*df$Dried_Fish
         +(235*0.45*df$White_Steamed_Bread+0.91*331*0.35*df$Pork+0.89*28*0.05*df$Scallion)*df$Pork_Buns
         +(0.91*331*0.45*df$Pork+235*0.35*df$White_Steamed_Bread+0.89*28*0.05*df$Scallion+26*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.91*331*0.4*df$Pork+235*0.35*df$White_Steamed_Bread+0.9*25*0.15*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.91*331*0.4*df$Pork+235*0.35*df$White_Steamed_Bread+0.89*20*0.15*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.91*331*0.3*df$Pork+235*0.35*df$White_Steamed_Bread+0.9*25*0.1*df$Chinese_Chives+0.1*0.59*103*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$protein = (2.6*df$rice+1.1*df$White_Congee+0.4*df$Rice_Noodles+0.8*df$Vermicelli+8.5*df$Noodles
         + 11.9*df$Macaroni_Pasta+7.1*df$White_Steamed_Bread +10.1*df$Oatmeal+7.9*df$Oil_Cake
         +6.9*df$Deep_fried_dough_sticks+8*df$Baked_Cake+11.1*df$Fish_balls+13.4*df$Cuttlefish_Balls
         +0.86*1.4*df$Sweet_Potato+2.9*df$Taro+0.94*2.6*df$Potato+0.91*0.9*df$Jicama+0.84*13.8*df$Salted_Duck_Egg
         +0.9*14.2*df$Century_Egg+25.1*df$Pork_Floss+11.8*df$Ham_Sausage+0.87*13.1*df$Chicken_Egg+0.87*12.6*df$Duck_Egg
         +0.91*15.1*df$Pork+0.69*17.55*df$Pork_Chops+20*df$Beef+18.5*df$Mutton+0.63*20.3*df$Chicken
         +0.68*15.5*df$Duck+0.96*15.2*df$Pork_Tripe+19.2*df$Pork_Liver+0.6*22.6*df$Pork_Trotters
         +12.2*df$Pork_Blood+19.2*df$Chicken_Gizzard+0.69*19*df$Chicken_Wings+0.6*23.9*df$Chicken_Feet
         +0.58*16.6*df$Grass_Carp+0.61*17.8*df$Silver_Carp+0.54*17.1*df$Crucian_Carp+0.58*18.6*df$Perch
         +0.64*17.35*df$Yellow_Croaker+0.54*18.6*df$Eel+0.67*19.8*df$Sardine+0.63*20.1*df$Black_Carp 
         +0.49*14.4*df$Mackerel+0.72*18.7*df$Spanish_Mackerel+0.7*18.5*df$Pomfret+0.76*17.7*df$Hairtail
         +0.61*19.9*df$Mandarin_Fish+0.64*17.6*df$Dike_Fish+0.59*18.3*df$Bream+0.7*18.5*df$Horse_Mackerel
         +0.67*18*df$Rice_Eel+0.97*17.4*df$Squid+10.6*df$Octopus+11.6*df$Crab+0.59*18.6*df$Sea_Shrimp
         +0.41*15.7*df$Snail+0.39*10.1*df$Clam+5.3*df$Oyster+0.57*7.3*df$Razor_Clam+0.49*11.4*df$Mussel
         +4.85*df$Jellyfish+3.4*df$Fresh_Milk_Boxed_Milk+19.9*df$Milk_Powder+2.8*df$Yogurt+2.4*df$Soy_Milk
         +2.9*df$Breakfast_Milk_Breakfast_Drink+0.53*12*df$Peanuts+0.745*17.51*df$Other_Nuts+35.2*df$Soybeans
         +21.6*df$Mung_Beans+3*df$Soybean_Milk+6.6*df$Tofu+14.9*df$Dried_Tofu+51.6*df$Tofu_Skin+21.5*df$Tofu_Strips
         +17*df$Fried_Tofu+5.4*df$Soybean_Sprouts+1.7*df$Mung_Bean_Sprouts+0.96*2.5*df$Green_Beans 
         +0.88*2.5*df$Snow_Peas+0.96*2*df$String_Beans+0.95*2.6*df$White_Radish+1.7*df$Carrot_Leaves
         +0.96*1*df$Carrot+0.7*df$White_Radish_Leaves+0.88*1.2*df$Lotus_Root+0.63*2.6*df$Bamboo_Shoots
         +0.82*1.7*df$Cauliflower+2.7*df$Baby_Bok_Choy+0.94*1.4*df$Bokchoy+0.89*1.6*df$Chinese_Cabbage
         +0.9*1.1*df$Onion+0.85*4.5*df$Garlic+0.12*1.2*df$Water_Bamboo+0.74*2.8*df$Amaranth+0.86*0.9*df$Cabbage
         +0.9*2.4*df$Chinese_Chives+2.2*df$Water_Spinach+0.89*2.6*df$Spinach+0.94*2*df$Mustard_Greens+0.83*1.9*df$Turnip
         +0.98*3.1*df$Chinese_Broccoli+0.88*2.9*df$Shepherds_Purse+0.67*1.2*df$Celery+0.96*1.8*df$Rapeseed
         +0.94*1.6*df$Lettuce+0.8*0.3*df$Winter_Melon+0.92*0.8*df$Cucumber+0.83*1.3*df$Luffa
         +0.81*1*df$Bitter_Melon+0.85*0.7*df$Pumpkin+1.2*df$Chayote+2*df$Tomato+0.8*1.3*df$Chili_Pepper
         +0.95*1.1*df$Eggplant+0.91*0.8*df$Green_Pepper+1.5*df$Wood_Ear_Mushroom+2.4*df$Enoki_Mushroom
         +0.99*2.7*df$Mushroom+2.2*df$Shiitake_Mushroom+0.89*1.4*df$Scallion+1.2*df$Kelp
         +0.85*0.4*df$Apple+0.7*1.1*df$Banana+0.74*0.8*df$Orange+0.69*0.8*df$Pomelo+0.82*0.3*df$Pear
         +0.89*0.6*df$Peach+0.6*0.6*df$Mango+0.68*0.5*df$Pineapple+0.78*0.4*df$Muskmelon+0.86*0.4*df$Grape
         +0.92*1.1*df$Persimmon+0.5*1.2*df$Longan+0.73*0.9*df$Lychee+0.62*0.8*df$Loquat+0.59*0.5*df$Watermelon
         +0.97*1*df$Strawberry+0.83*0.8*df$Kiwi+0.69*1.1*df$Dragon_Fruit+0.78*1.2*df$Water_Chestnut
         +0.95*20*df$Dried_Shiitake+0.98*1.8*df$Dried_Kelp+26.7*df$Dried_Seaweed+55.6*df$Dried_Scallop+46.1*df$Dried_Fish
         +(7.1*0.45*df$White_Steamed_Bread+0.91*15.1*0.35*df$Pork+0.89*1.4*0.05*df$Scallion)*df$Pork_Buns
         +(0.91*15.1*0.45*df$Pork+7.1*0.35*df$White_Steamed_Bread+0.89*1.4*0.05*df$Scallion+2.2*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.91*15.1*0.4*df$Pork+7.1*0.35*df$White_Steamed_Bread+0.9*2.4*0.15*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.91*15.1*0.4*df$Pork+7.1*0.35*df$White_Steamed_Bread+0.89*1.6*0.15*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.91*15.1*0.3*df$Pork+7.1*0.35*df$White_Steamed_Bread+0.9*2.4*0.1*df$Chinese_Chives+0.1*0.59*18.6*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$fat = (0.3*df$rice+0.3*df$White_Congee+0.8*df$Rice_Noodles+0.2*df$Vermicelli+1.6*df$Noodles
         + 0.1*df$Macaroni_Pasta+1.3*df$White_Steamed_Bread +0.2*df$Oatmeal+22.9*df$Oil_Cake
         +17.6*df$Deep_fried_dough_sticks+2.1*df$Baked_Cake+1.3*df$Fish_balls+4.7*df$Cuttlefish_Balls
         +0.86*0.2*df$Sweet_Potato+0.1*df$Taro+0.94*0.2*df$Potato+0.91*0.1*df$Jicama+0.84*13.5*df$Salted_Duck_Egg
         +0.9*10.7*df$Century_Egg+26*df$Pork_Floss+23.2*df$Ham_Sausage+0.87*8.6*df$Chicken_Egg+0.87*13*df$Duck_Egg
         +0.91*30.1*df$Pork+0.69*22.85*df$Pork_Chops+8.7*df$Beef+6.5*df$Mutton+0.63*6.7*df$Chicken
         +0.68*19.7*df$Duck+0.96*5.1*df$Pork_Tripe+4.7*df$Pork_Liver+0.6*18.8*df$Pork_Trotters
         +0.3*df$Pork_Blood+2.8*df$Chicken_Gizzard+0.69*11.5*df$Chicken_Wings+0.6*16.4*df$Chicken_Feet
         +0.58*5.2*df$Grass_Carp+0.61*3.6*df$Silver_Carp+0.54*2.7*df$Crucian_Carp+0.58*3.4*df$Perch
         +0.64*3.8*df$Yellow_Croaker+0.54*10.8*df$Eel+0.67*1.1*df$Sardine+0.63*4.2*df$Black_Carp 
         +0.49*39.4*df$Mackerel+0.72*11.3*df$Spanish_Mackerel+0.7*7.3*df$Pomfret+0.76*4.9*df$Hairtail
         +0.61*4.2*df$Mandarin_Fish+0.64*12.8*df$Dike_Fish+0.59*6.3*df$Bream+0.7*3.4*df$Horse_Mackerel
         +0.67*1.4*df$Rice_Eel+0.97*1.6*df$Squid+0.4*df$Octopus+1.2*df$Crab+0.59*0.8*df$Sea_Shrimp
         +0.41*1.2*df$Snail+0.39*1.1*df$Clam+2.1*df$Oyster+0.57*0.3*df$Razor_Clam+0.49*1.7*df$Mussel
         +0.3*df$Jellyfish+3.7*df$Fresh_Milk_Boxed_Milk+22.3*df$Milk_Powder+2.6*df$Yogurt+1.5*df$Soy_Milk
         +3.2*df$Breakfast_Milk_Breakfast_Drink+0.53*25.4*df$Peanuts+0.745*36.32*df$Other_Nuts+16*df$Soybeans
         +0.8*df$Mung_Beans+1.6*df$Soybean_Milk+5.3*df$Tofu+11.3*df$Dried_Tofu+23*df$Tofu_Skin+10.5*df$Tofu_Strips
         +17.6*df$Fried_Tofu+1.6*df$Soybean_Sprouts+0.1*df$Mung_Bean_Sprouts+0.96*0.2*df$Green_Beans 
         +0.88*0.3*df$Snow_Peas+0.96*0.4*df$String_Beans+0.95*0.1*df$White_Radish+0.4*df$Carrot_Leaves
         +0.96*0.2*df$Carrot+0.3*df$White_Radish_Leaves+0.88*0.2*df$Lotus_Root+0.63*0.2*df$Bamboo_Shoots
         +0.82*0.2*df$Cauliflower+0.2*df$Baby_Bok_Choy+0.94*0.3*df$Bokchoy+0.89*0.2*df$Chinese_Cabbage
         +0.9*0.2*df$Onion+0.85*0.2*df$Garlic+0.12*0.1*df$Water_Bamboo+0.74*0.3*df$Amaranth+0.86*0.2*df$Cabbage
         +0.9*0.4*df$Chinese_Chives+0.2*df$Water_Spinach+0.89*0.3*df$Spinach+0.94*0.4*df$Mustard_Greens+0.83*0.2*df$Turnip
         +0.98*0.3*df$Chinese_Broccoli+0.88*0.4*df$Shepherds_Purse+0.67*0.2*df$Celery+0.96*0.2*df$Rapeseed
         +0.94*0.4*df$Lettuce+0.8*0.2*df$Winter_Melon+0.92*0.2*df$Cucumber+0.83*0.2*df$Luffa
         +0.81*0.1*df$Bitter_Melon+0.85*0.1*df$Pumpkin+0.1*df$Chayote+0.6*df$Tomato+0.8*0.4*df$Chili_Pepper
         +0.95*0.1*df$Eggplant+0.91*0.3*df$Green_Pepper+0.2*df$Wood_Ear_Mushroom+0.4*df$Enoki_Mushroom
         +0.99*0.1*df$Mushroom+0.3*df$Shiitake_Mushroom+0.89*0.3*df$Scallion+0.1*df$Kelp
         +0.85*0.2*df$Apple+0.7*0.2*df$Banana+0.74*0.2*df$Orange+0.69*0.2*df$Pomelo+0.82*0.1*df$Pear
         +0.89*0.1*df$Peach+0.6*0.2*df$Mango+0.68*0.1*df$Pineapple+0.78*0.1*df$Muskmelon+0.86*0.3*df$Grape
         +0.92*0.15*df$Persimmon+0.5*0.1*df$Longan+0.73*0.2*df$Lychee+0.62*0.2*df$Loquat+0.59*0.3*df$Watermelon
         +0.97*0.2*df$Strawberry+0.83*0.6*df$Kiwi+0.69*0.2*df$Dragon_Fruit+0.78*0.2*df$Water_Chestnut
         +0.95*1.2*df$Dried_Shiitake+0.98*0.1*df$Dried_Kelp+1.1*df$Dried_Seaweed+2.4*df$Dried_Scallop+3.4*df$Dried_Fish
         +(1.3*0.45*df$White_Steamed_Bread+0.91*30.1*0.35*df$Pork+0.89*0.3*0.05*df$Scallion)*df$Pork_Buns
         +(0.91*30.1*0.45*df$Pork+1.3*0.35*df$White_Steamed_Bread+0.89*0.3*0.05*df$Scallion+0.3*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.91*30.1*0.4*df$Pork+1.3*0.35*df$White_Steamed_Bread+0.9*0.4*0.15*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.91*30.1*0.4*df$Pork+1.3*0.35*df$White_Steamed_Bread+0.89*0.2*0.15*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.91*30.1*0.3*df$Pork+1.3*0.35*df$White_Steamed_Bread+0.9*0.4*0.1*df$Chinese_Chives+0.1*0.59*0.8*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$carbohydrate = (25.9*df$rice+9.9*df$White_Congee+85.8*df$Rice_Noodles+83.7*df$Vermicelli+59.5*df$Noodles
         + 75.8*df$Macaroni_Pasta+50.9*df$White_Steamed_Bread +77.4*df$Oatmeal+42.4*df$Oil_Cake
         +51*df$Deep_fried_dough_sticks+62.7*df$Baked_Cake+12.7*df$Fish_balls+8*df$Cuttlefish_Balls
         +0.86*25.2*df$Sweet_Potato+13*df$Taro+0.94*17.8*df$Potato+0.91*13.4*df$Jicama+0.84*0*df$Salted_Duck_Egg
         +0.9*4.5*df$Century_Egg+39.7*df$Pork_Floss+6*df$Ham_Sausage+0.87*2.4*df$Chicken_Egg+0.87*3.1*df$Duck_Egg
         +0.91*0*df$Pork+0.69*0.85*df$Pork_Chops+0.5*df$Beef+1.6*df$Mutton+0.63*0.9*df$Chicken
         +0.68*0.2*df$Duck+0.96*0.7*df$Pork_Tripe+1.8*df$Pork_Liver+0.6*0*df$Pork_Trotters
         +0.9*df$Pork_Blood+4*df$Chicken_Gizzard+0.69*5.5*df$Chicken_Wings+0.6*2.7*df$Chicken_Feet
         +0.58*0*df$Grass_Carp+0.61*0*df$Silver_Carp+0.54*3.8*df$Crucian_Carp+0.58*0*df$Perch
         +0.64*0.4*df$Yellow_Croaker+0.54*2.3*df$Eel+0.67*0*df$Sardine+0.63*0*df$Black_Carp 
         +0.49*0.2*df$Mackerel+0.72*4.4*df$Spanish_Mackerel+0.7*0*df$Pomfret+0.76*3.1*df$Hairtail
         +0.61*0*df$Mandarin_Fish+0.64*1.3*df$Dike_Fish+0.59*1.2*df$Bream+0.7*4.8*df$Horse_Mackerel
         +0.67*1.2*df$Rice_Eel+0.97*0*df$Squid+1.4*df$Octopus+1.1*df$Crab+0.59*5.4*df$Sea_Shrimp
         +0.41*6.6*df$Snail+0.39*2.8*df$Clam+8.2*df$Oyster+0.57*2.1*df$Razor_Clam+0.49*4.7*df$Mussel
         +7.8*df$Jellyfish+5.1*df$Fresh_Milk_Boxed_Milk+50.5*df$Milk_Powder+12.9*df$Yogurt+1.8*df$Soy_Milk
         +7.6*df$Breakfast_Milk_Breakfast_Drink+0.53*13*df$Peanuts+0.745*27.67*df$Other_Nuts+34.4*df$Soybeans
         +62*df$Mung_Beans+1.2*df$Soybean_Milk+3.4*df$Tofu+9.6*df$Dried_Tofu+12.5*df$Tofu_Skin+6.2*df$Tofu_Strips
         +4.9*df$Fried_Tofu+4.5*df$Soybean_Sprouts+2.6*df$Mung_Bean_Sprouts+0.96*6.7*df$Green_Beans 
         +0.88*4.9*df$Snow_Peas+0.96*5.7*df$String_Beans+0.95*4*df$White_Radish+11.3*df$Carrot_Leaves
         +0.96*8.8*df$Carrot+1.7*df$White_Radish_Leaves+0.88*11.5*df$Lotus_Root+0.63*3.6*df$Bamboo_Shoots
         +0.82*4.2*df$Cauliflower+3.3*df$Baby_Bok_Choy+0.94*2.4*df$Bokchoy+0.89*3.4*df$Chinese_Cabbage
         +0.9*9*df$Onion+0.85*27.6*df$Garlic+0.12*2.4*df$Water_Bamboo+0.74*5*df$Amaranth+0.86*4*df$Cabbage
         +0.9*4.5*df$Chinese_Chives+4*df$Water_Spinach+0.89*4.5*df$Spinach+0.94*4.7*df$Mustard_Greens+0.83*7.4*df$Turnip
         +0.98*4.1*df$Chinese_Broccoli+0.88*4.7*df$Shepherds_Purse+0.67*4.5*df$Celery+0.96*2.9*df$Rapeseed
         +0.94*1.1*df$Lettuce+0.8*2.4*df$Winter_Melon+0.92*2.9*df$Cucumber+0.83*4*df$Luffa
         +0.81*4.9*df$Bitter_Melon+0.85*5.3*df$Pumpkin+3.8*df$Chayote+2.6*df$Tomato+0.8*8.9*df$Chili_Pepper
         +0.95*4.8*df$Eggplant+0.91*5.2*df$Green_Pepper+6*df$Wood_Ear_Mushroom+6*df$Enoki_Mushroom
         +0.99*4.1*df$Mushroom+5.2*df$Shiitake_Mushroom+0.89*6.6*df$Scallion+2.1*df$Kelp
         +0.85*13.7*df$Apple+0.7*20.8*df$Banana+0.74*11.1*df$Orange+0.69*9.5*df$Pomelo+0.82*13.1*df$Pear
         +0.89*10.1*df$Peach+0.6*8.3*df$Mango+0.68*10.8*df$Pineapple+0.78*6.2*df$Muskmelon+0.86*10.3*df$Grape
         +0.92*40.65*df$Persimmon+0.5*16.6*df$Longan+0.73*16.6*df$Lychee+0.62*9.3*df$Loquat+0.59*6.8*df$Watermelon
         +0.97*7.1*df$Strawberry+0.83*14.5*df$Kiwi+0.69*13.3*df$Dragon_Fruit+0.78*14.2*df$Water_Chestnut
         +0.95*61.7*df$Dried_Shiitake+0.98*23.4*df$Dried_Kelp+44.1*df$Dried_Seaweed+5.1*df$Dried_Scallop+22*df$Dried_Fish
         +(50.9*0.45*df$White_Steamed_Bread+0.35*0.91*0*df$Pork+0.89*6.6*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0*df$Pork+50.9*0.35*df$White_Steamed_Bread+0.89*6.6*0.05*df$Scallion+5.2*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0*df$Pork+50.9*0.35*df$White_Steamed_Bread+0.15*0.9*4.5*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0*df$Pork+50.9*0.35*df$White_Steamed_Bread+0.15*0.89*3.4*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0*df$Pork+50.9*0.35*df$White_Steamed_Bread+0.1*0.9*4.5*df$Chinese_Chives+0.1*0.59*5.4*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$insoluble_dietary_fiber = (0.3*df$rice+0.1*df$White_Congee+0*df$Rice_Noodles+1.1*df$Vermicelli+1.5*df$Noodles
         +0.4*df$Macaroni_Pasta+0*df$White_Steamed_Bread +6*df$Oatmeal+2*df$Oil_Cake
         +0.9*df$Deep_fried_dough_sticks+2.1*df$Baked_Cake+0*df$Fish_balls+4*df$Cuttlefish_Balls
         +0.86*1*df$Sweet_Potato+0.3*df$Taro+0.94*1.1*df$Potato+0.91*0.8*df$Jicama+0.84*0*df$Salted_Duck_Egg
         +0.9*0*df$Century_Egg+0*df$Pork_Floss+0*df$Ham_Sausage+0.87*0*df$Chicken_Egg+0.87*0*df$Duck_Egg
         +0.91*0*df$Pork+0.69*0*df$Pork_Chops+0*df$Beef+0*df$Mutton+0.63*0*df$Chicken
         +0.68*0*df$Duck+0.96*0*df$Pork_Tripe+0*df$Pork_Liver+0.6*0*df$Pork_Trotters
         +0*df$Pork_Blood+0*df$Chicken_Gizzard+0.69*0*df$Chicken_Wings+0.6*0*df$Chicken_Feet
         +0.58*0*df$Grass_Carp+0.61*0*df$Silver_Carp+0.54*3.8*df$Crucian_Carp+0.58*0*df$Perch
         +0.64*0*df$Yellow_Croaker+0.54*0*df$Eel+0.67*0*df$Sardine+0.63*0*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*0*df$Pomfret+0.76*0*df$Hairtail
         +0.61*0*df$Mandarin_Fish+0.64*0*df$Dike_Fish+0.59*0*df$Bream+0.7*0*df$Horse_Mackerel
         +0.67*0*df$Rice_Eel+0.97*0*df$Squid+0*df$Octopus+0*df$Crab+0.59*0*df$Sea_Shrimp
         +0.41*0*df$Snail+0.39*0*df$Clam+0*df$Oyster+0.57*0*df$Razor_Clam+0.49*0*df$Mussel
         +0*df$Jellyfish+0*df$Fresh_Milk_Boxed_Milk+0*df$Milk_Powder+0*df$Yogurt+0*df$Soy_Milk
         +0*df$Breakfast_Milk_Breakfast_Drink+0.53*7.7*df$Peanuts+0.745*7.64*df$Other_Nuts+12.8*df$Soybeans
         +6.4*df$Mung_Beans+0*df$Soybean_Milk+0*df$Tofu+0*df$Dried_Tofu+0*df$Tofu_Skin+1.1*df$Tofu_Strips
         +0.6*df$Fried_Tofu+1.5*df$Soybean_Sprouts+1.2*df$Mung_Bean_Sprouts+0.96*2.1*df$Green_Beans 
         +0.88*1.4*df$Snow_Peas+0.96*1.5*df$String_Beans+0.95*0*df$White_Radish+4*df$Carrot_Leaves
         +0.96*1.1*df$Carrot+1.4*df$White_Radish_Leaves+0.88*2.2*df$Lotus_Root+0.63*1.8*df$Bamboo_Shoots
         +0.82*2.1*df$Cauliflower+1.5*df$Baby_Bok_Choy+0.94*0*df$Bokchoy+0.89*0.9*df$Chinese_Cabbage
         +0.9*0.9*df$Onion+0.85*1.1*df$Garlic+0.12*0.9*df$Water_Bamboo+0.74*2.2*df$Amaranth+0.86*0*df$Cabbage
         +0.9*0*df$Chinese_Chives+0*df$Water_Spinach+0.89*1.7*df$Spinach+0.94*1.6*df$Mustard_Greens+0.83*1.4*df$Turnip
         +0.98*0*df$Chinese_Broccoli+0.88*1.7*df$Shepherds_Purse+0.67*1.2*df$Celery+0.96*0.9*df$Rapeseed
         +0.94*0*df$Lettuce+0.8*0*df$Winter_Melon+0.92*0.5*df$Cucumber+0.83*0*df$Luffa
         +0.81*1.4*df$Bitter_Melon+0.85*0.8*df$Pumpkin+1.2*df$Chayote+0.8*df$Tomato+0.8*3.2*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*0*df$Green_Pepper+2.6*df$Wood_Ear_Mushroom+2.7*df$Enoki_Mushroom
         +0.99*2.1*df$Mushroom+3.3*df$Shiitake_Mushroom+0.89*0*df$Scallion+0.5*df$Kelp
         +0.85*1.7*df$Apple+0.7*0*df$Banana+0.74*0.6*df$Orange+0.69*0.4*df$Pomelo+0.82*2.6*df$Pear
         +0.89*1*df$Peach+0.6*1.3*df$Mango+0.68*1.3*df$Pineapple+0.78*0.4*df$Muskmelon+0.86*1*df$Grape
         +0.92*2*df$Persimmon+0.5*0.4*df$Longan+0.73*0.5*df$Lychee+0.62*0.8*df$Loquat+0.59*0.2*df$Watermelon
         +0.97*1.1*df$Strawberry+0.83*2.6*df$Kiwi+0.69*1.6*df$Dragon_Fruit+0.78*1.1*df$Water_Chestnut
         +0.95*31.6*df$Dried_Shiitake+0.98*6.1*df$Dried_Kelp+21.6*df$Dried_Seaweed+0*df$Dried_Scallop+0*df$Dried_Fish
         +(0*50.9*0.45*df$White_Steamed_Bread+0.35*0.91*0*df$Pork+0.89*6.6*0.05*0*df$Scallion)*df$Pork_Buns
         +(0*0.45*0.91*0*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.89*6.6*0.05*0*df$Scallion+3.3*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0*0*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.15*0.9*4.5*0*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0*0*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.15*0.89*0.9*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0*0*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.1*0.9*4.5*0*df$Chinese_Chives+0.1*0.59*0*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$cholesterol = (0*df$rice+0*df$White_Congee+0*df$Rice_Noodles+0*df$Vermicelli+0*df$Noodles
         +0*df$Macaroni_Pasta+0*df$White_Steamed_Bread +0*df$Oatmeal+0*df$Oil_Cake
         +0*df$Deep_fried_dough_sticks+0*df$Baked_Cake+77*df$Fish_balls+32*df$Cuttlefish_Balls
         +0.86*0*df$Sweet_Potato+0*df$Taro+0.94*0*df$Potato+0.91*0*df$Jicama+0.84*608*df$Salted_Duck_Egg
         +0.9*0*df$Century_Egg+0*df$Pork_Floss+0*df$Ham_Sausage+0.87*648*df$Chicken_Egg+0.87*565*df$Duck_Egg
         +0.91*86*df$Pork+0.69*142.5*df$Pork_Chops+58*df$Beef+82*df$Mutton+0.63*106*df$Chicken
         +0.68*94*df$Duck+0.96*165*df$Pork_Tripe+180*df$Pork_Liver+0.6*192*df$Pork_Trotters
         +51*df$Pork_Blood+174*df$Chicken_Gizzard+0.69*81*df$Chicken_Wings+0.6*103*df$Chicken_Feet
         +0.58*86*df$Grass_Carp+0.61*99*df$Silver_Carp+0.54*130*df$Crucian_Carp+0.58*86*df$Perch
         +0.64*81*df$Yellow_Croaker+0.54*177*df$Eel+0.67*158*df$Sardine+0.63*108*df$Black_Carp 
         +0.49*60*df$Mackerel+0.72*51*df$Spanish_Mackerel+0.7*77*df$Pomfret+0.76*76*df$Hairtail
         +0.61*124*df$Mandarin_Fish+0.64*0*df$Dike_Fish+0.59*94*df$Bream+0.7*78*df$Horse_Mackerel
         +0.67*126*df$Rice_Eel+0.97*268*df$Squid+114*df$Octopus+65*df$Crab+0.59*148*df$Sea_Shrimp
         +0.41*0*df$Snail+0.39*156*df$Clam+100*df$Oyster+0.57*131*df$Razor_Clam+0.49*123*df$Mussel
         +9*df$Jellyfish+21*df$Fresh_Milk_Boxed_Milk+79*df$Milk_Powder+8*df$Yogurt+5*df$Soy_Milk
         +19*df$Breakfast_Milk_Breakfast_Drink+0.53*0*df$Peanuts+0.745*0*df$Other_Nuts+0*df$Soybeans
         +0*df$Mung_Beans+0*df$Soybean_Milk+0*df$Tofu+0*df$Dried_Tofu+0*df$Tofu_Skin+0*df$Tofu_Strips
         +0*df$Fried_Tofu+0*df$Soybean_Sprouts+0*df$Mung_Bean_Sprouts+0.96*0*df$Green_Beans 
         +0.88*0*df$Snow_Peas+0.96*0*df$String_Beans+0.95*0*df$White_Radish+0*df$Carrot_Leaves
         +0.96*0*df$Carrot+0*df$White_Radish_Leaves+0.88*0*df$Lotus_Root+0.63*0*df$Bamboo_Shoots
         +0.82*0*df$Cauliflower+0*df$Baby_Bok_Choy+0.94*0*df$Bokchoy+0.89*0*df$Chinese_Cabbage
         +0.9*0*df$Onion+0.85*0*df$Garlic+0.12*0*df$Water_Bamboo+0.74*0*df$Amaranth+0.86*0*df$Cabbage
         +0.9*0*df$Chinese_Chives+0*df$Water_Spinach+0.89*0*df$Spinach+0.94*0*df$Mustard_Greens+0.83*0*df$Turnip
         +0.98*0*df$Chinese_Broccoli+0.88*0*df$Shepherds_Purse+0.67*0*df$Celery+0.96*0*df$Rapeseed
         +0.94*0*df$Lettuce+0.8*0*df$Winter_Melon+0.92*0*df$Cucumber+0.83*0*df$Luffa
         +0.81*0*df$Bitter_Melon+0.85*0*df$Pumpkin+0*df$Chayote+0*df$Tomato+0.8*0*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*0*df$Green_Pepper+0*df$Wood_Ear_Mushroom+0*df$Enoki_Mushroom
         +0.99*0*df$Mushroom+0*df$Shiitake_Mushroom+0.89*0*df$Scallion+0*df$Kelp
         +0.85*0*df$Apple+0.7*0*df$Banana+0.74*0*df$Orange+0.69*0*df$Pomelo+0.82*0*df$Pear
         +0.89*0*df$Peach+0.6*0*df$Mango+0.68*0*df$Pineapple+0.78*0*df$Muskmelon+0.86*0*df$Grape
         +0.92*0*df$Persimmon+0.5*0*df$Longan+0.73*0*df$Lychee+0.62*0*df$Loquat+0.59*0*df$Watermelon
         +0.97*0*df$Strawberry+0.83*0*df$Kiwi+0.69*0*df$Dragon_Fruit+0.78*0*df$Water_Chestnut
         +0.95*0*df$Dried_Shiitake+0.98*0*df$Dried_Kelp+0*df$Dried_Seaweed+348*df$Dried_Scallop+307*df$Dried_Fish
         +(0*50.9*0.45*df$White_Steamed_Bread+0.35*0.91*86*df$Pork+0.89*6.6*0.05*0*df$Scallion)*df$Pork_Buns
         +(0*0.45*0.91*0*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.89*6.6*0.05*0*df$Scallion+0*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*86*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.15*0.9*4.5*0*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*86*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.15*0.89*3.4*0.89*0.9*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*86*df$Pork+0*50.9*0.35*df$White_Steamed_Bread+0.1*0.9*4.5*0*df$Chinese_Chives+0.1*0.59*148*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$ash_content = (0.3*df$rice+0.1*df$White_Congee+0.3*df$Rice_Noodles+0.3*df$Vermicelli+0.7*df$Noodles
         +0.4*df$Macaroni_Pasta+0.4*df$White_Steamed_Bread +2.1*df$Oatmeal+2*df$Oil_Cake
         +2.7*df$Deep_fried_dough_sticks+1.3*df$Baked_Cake+2.4*df$Fish_balls+2.9*df$Cuttlefish_Balls
         +0.86*0.6*df$Sweet_Potato+1*df$Taro+0.94*0.8*df$Potato+0.91*0.4*df$Jicama+0.84*4.2*df$Salted_Duck_Egg
         +0.9*2.2*df$Century_Egg+5.6*df$Pork_Floss+2.8*df$Ham_Sausage+0.87*0.9*df$Chicken_Egg+0.87*1*df$Duck_Egg
         +0.91*0.8*df$Pork+0.69*0.8*df$Pork_Chops+1.1*df$Beef+1*df$Mutton+0.63*1.1*df$Chicken
         +0.68*0.7*df$Duck+0.96*0.8*df$Pork_Tripe+1.7*df$Pork_Liver+0.6*0.4*df$Pork_Trotters
         +0.8*df$Pork_Blood+0.9*df$Chicken_Gizzard+0.69*0.7*df$Chicken_Wings+0.6*0.6*df$Chicken_Feet
         +0.58*1.1*df$Grass_Carp+0.61*1.2*df$Silver_Carp+0.54*1*df$Crucian_Carp+0.58*1.5*df$Perch
         +0.64*1.45*df$Yellow_Croaker+0.54*1.2*df$Eel+0.67*1.3*df$Sardine+0.63*2.4*df$Black_Carp 
         +0.49*0.8*df$Mackerel+0.72*1.3*df$Spanish_Mackerel+0.7*1.4*df$Pomfret+0.76*1*df$Hairtail
         +0.61*1.5*df$Mandarin_Fish+0.64*1.4*df$Dike_Fish+0.59*1.1*df$Bream+0.7*1.3*df$Horse_Mackerel
         +0.67*1.4*df$Rice_Eel+0.97*1.1*df$Squid+1.2*df$Octopus+1.7*df$Crab+0.59*1.6*df$Sea_Shrimp
         +0.41*2.9*df$Snail+0.39*1.9*df$Clam+2.4*df$Oyster+0.57*1.9*df$Razor_Clam+0.49*2.3*df$Mussel
         +14.3*df$Jellyfish+0.7*df$Fresh_Milk_Boxed_Milk+4.7*df$Milk_Powder+0.7*df$Yogurt+0.3*df$Soy_Milk
         +0.6*df$Breakfast_Milk_Breakfast_Drink+0.53*1.3*df$Peanuts+0.745*2.86*df$Other_Nuts+4.6*df$Soybeans
         +3.3*df$Mung_Beans+0.4*df$Soybean_Milk+0.9*df$Tofu+3.1*df$Dried_Tofu+3.5*df$Tofu_Skin+3.4*df$Tofu_Strips
         +1.7*df$Fried_Tofu+0.6*df$Soybean_Sprouts+0.3*df$Mung_Bean_Sprouts+0.96*0.6*df$Green_Beans 
         +0.88*0.4*df$Snow_Peas+0.96*0.6*df$String_Beans+0.95*0.6*df$White_Radish+0.8*df$Carrot_Leaves
         +0.96*4.4*df$Carrot+4.7*df$White_Radish_Leaves+0.88*0.7*df$Lotus_Root+0.63*0.8*df$Bamboo_Shoots
         +0.82*0.7*df$Cauliflower+1.2*df$Baby_Bok_Choy+0.94*1.1*df$Bokchoy+0.89*0.7*df$Chinese_Cabbage
         +0.9*0.5*df$Onion+0.85*1.1*df$Garlic+0.12*1.3*df$Water_Bamboo+0.74*1.7*df$Amaranth+0.86*0.4*df$Cabbage
         +0.9*0.7*df$Chinese_Chives+1.3*df$Water_Spinach+0.89*1.4*df$Spinach+0.94*1.4*df$Mustard_Greens+0.83*0.9*df$Turnip
         +0.98*1.5*df$Chinese_Broccoli+0.88*1.4*df$Shepherds_Purse+0.67*1*df$Celery+0.96*1*df$Rapeseed
         +0.94*0.2*df$Lettuce+0.8*0.2*df$Winter_Melon+0.92*0.3*df$Cucumber+0.83*0.4*df$Luffa
         +0.81*0.6*df$Bitter_Melon+0.85*0.4*df$Pumpkin+0.6*df$Chayote+1.3*df$Tomato+0.8*0.6*df$Chili_Pepper
         +0.95*0.6*df$Eggplant+0.91*0.3*df$Green_Pepper+0.5*df$Wood_Ear_Mushroom+1*df$Enoki_Mushroom
         +0.99*0.7*df$Mushroom+0.6*df$Shiitake_Mushroom+0.89*0.6*df$Scallion+2.2*df$Kelp
         +0.85*0.2*df$Apple+0.7*0.8*df$Banana+0.74*0.5*df$Orange+0.69*0.5*df$Pomelo+0.82*0.3*df$Pear
         +0.89*0.4*df$Peach+0.6*0.3*df$Mango+0.68*0.2*df$Pineapple+0.78*0.4*df$Muskmelon+0.86*0.3*df$Grape
         +0.92*0.9*df$Persimmon+0.5*0.7*df$Longan+0.73*0.4*df$Lychee+0.62*0.4*df$Loquat+0.59*0.2*df$Watermelon
         +0.97*0.4*df$Strawberry+0.83*0.7*df$Kiwi+0.69*0.6*df$Dragon_Fruit+0.78*0.8*df$Water_Chestnut
         +0.95*4.8*df$Dried_Shiitake+0.98*4.2*df$Dried_Kelp+15.4*df$Dried_Seaweed+9.5*df$Dried_Scallop+8.3*df$Dried_Fish
         +(0.4*0.45*df$White_Steamed_Bread+0.35*0.91*86*df$Pork+0.89*0.6*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0.8*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.89*0.6*0.05*df$Scallion+0.6*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0.8*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.15*0.9*0.7*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0.8*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.15*0.89*0.7*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0.8*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.1*0.9*0.7*df$Chinese_Chives+0.1*0.59*1.6*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$total_vitamin_A = (
         0*df$rice
         +0*df$White_Congee
         +0*df$Rice_Noodles
         +0*df$Vermicelli
         +0*df$Noodles
         +0*df$Macaroni_Pasta
         +0*df$White_Steamed_Bread
         +0*df$Oatmeal
         +0*df$Oil_Cake
         +0*df$Deep_fried_dough_sticks
         +0*df$Baked_Cake
         +5*df$Fish_balls
         +4*df$Cuttlefish_Balls
         +0.86*18*df$Sweet_Potato
         +0*df$Taro
         +0.94*1*df$Potato
         +0.91*0*df$Jicama
         +0.84*0*df$Salted_Duck_Egg
         +0.9*215*df$Century_Egg
         +0*df$Pork_Floss
         +158*df$Ham_Sausage
         +0.87*255*df$Chicken_Egg
         +0.87*261*df$Duck_Egg
         +0.91*15*df$Pork
         +0.69*9.5*df$Pork_Chops
         +3*df$Beef
         +8*df$Mutton
         +0.63*92*df$Chicken
         +0.68*52*df$Duck
         +0.96*3*df$Pork_Tripe
         +6502*df$Pork_Liver
         +0.6*3*df$Pork_Trotters
         +0*df$Pork_Blood
         +36*df$Chicken_Gizzard
         +0.69*28*df$Chicken_Wings
         +0.6*37*df$Chicken_Feet
         +0.58*11*df$Grass_Carp
         +0.61*20*df$Silver_Carp
         +0.54*17*df$Crucian_Carp
         +0.58*19*df$Perch
         +0.64*52*df$Yellow_Croaker
         +0.54*0*df$Eel
         +0.67*0*df$Sardine
         +0.63*42*df$Black_Carp 
         +0.49*183*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*24*df$Pomfret+0.76*29*df$Hairtail
         +0.61*12*df$Mandarin_Fish+0.64*5*df$Dike_Fish+0.59*28*df$Bream+0.7*1*df$Horse_Mackerel
         +0.67*50*df$Rice_Eel+0.97*35*df$Squid+7*df$Octopus+0*df$Crab+0.59*48*df$Sea_Shrimp
         +0.41*26*df$Snail+0.39*21*df$Clam+27*df$Oyster+0.57*59*df$Razor_Clam+0.49*73*df$Mussel
         +14*df$Jellyfish+73*df$Fresh_Milk_Boxed_Milk+380*df$Milk_Powder+23*df$Yogurt+0*df$Soy_Milk
         +113*df$Breakfast_Milk_Breakfast_Drink+0.53*1*df$Peanuts+0.745*6.7*df$Other_Nuts+29*df$Soybeans
         +11*df$Mung_Beans+0*df$Soybean_Milk+0*df$Tofu+2*df$Dried_Tofu+23*df$Tofu_Skin+3*df$Tofu_Strips
         +3*df$Fried_Tofu+3*df$Soybean_Sprouts+1*df$Mung_Bean_Sprouts+0.96*17*df$Green_Beans 
         +0.88*40*df$Snow_Peas+0.96*35*df$String_Beans+0.95*0*df$White_Radish+81*df$Carrot_Leaves
         +0.96*344*df$Carrot+0*df$White_Radish_Leaves+0.88*0*df$Lotus_Root+0.63*0*df$Bamboo_Shoots
         +0.82*1*df$Cauliflower+95*df$Baby_Bok_Choy+0.94*154*df$Bokchoy+0.89*7*df$Chinese_Cabbage
         +0.9*2*df$Onion+0.85*3*df$Garlic+0.12*1*df$Water_Bamboo+0.74*176*df$Amaranth+0.86*1*df$Cabbage
         +0.9*133*df$Chinese_Chives+143*df$Water_Spinach+0.89*243*df$Spinach+0.94*26*df$Mustard_Greens+0.83*0*df$Turnip
         +0.98*0*df$Chinese_Broccoli+0.88*216*df$Shepherds_Purse+0.67*28*df$Celery+0.96*122*df$Rapeseed
         +0.94*2*df$Lettuce+0.8*0*df$Winter_Melon+0.92*8*df$Cucumber+0.83*13*df$Luffa
         +0.81*8*df$Bitter_Melon+0.85*74*df$Pumpkin+2*df$Chayote+96*df$Tomato+0.8*116*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*8*df$Green_Pepper+2*df$Wood_Ear_Mushroom+3*df$Enoki_Mushroom
         +0.99*1*df$Mushroom+0*df$Shiitake_Mushroom+0.89*10*df$Scallion+0*df$Kelp
         +0.85*4*df$Apple+0.7*3*df$Banana+0.74*13*df$Orange+0.69*1*df$Pomelo+0.82*2*df$Pear
         +0.89*2*df$Peach+0.6*75*df$Mango+0.68*2*df$Pineapple+0.78*3*df$Muskmelon+0.86*3*df$Grape
         +0.92*17*df$Persimmon+0.5*2*df$Longan+0.73*1*df$Lychee+0.62*0*df$Loquat+0.59*14*df$Watermelon
         +0.97*3*df$Strawberry+0.83*11*df$Kiwi+0.69*0*df$Dragon_Fruit+0.78*3*df$Water_Chestnut
         +0.95*2*df$Dried_Shiitake+0.98*20*df$Dried_Kelp+114*df$Dried_Seaweed+11*df$Dried_Scallop+0*df$Dried_Fish
         +(0*0.45*df$White_Steamed_Bread+0.35*0.91*15*df$Pork+0.89*10*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.89*10*0.05*df$Scallion+0.08*0*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.9*133*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.89*7*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.1*0.9*133*df$Chinese_Chives+0.1*0.59*48*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$carotene = (0*df$rice+0*df$White_Congee+0*df$Rice_Noodles+0*df$Vermicelli+0*df$Noodles
         +0*df$Macaroni_Pasta+0*df$White_Steamed_Bread +0*df$Oatmeal+0*df$Oil_Cake
         +0*df$Deep_fried_dough_sticks+0*df$Baked_Cake+0*df$Fish_balls+0*df$Cuttlefish_Balls
         +0.86*220*df$Sweet_Potato+0*df$Taro+0.94*6*df$Potato+0.91*0*df$Jicama+0.84*0*df$Salted_Duck_Egg
         +0.9*0*df$Century_Egg+0*df$Pork_Floss+0*df$Ham_Sausage+0.87*0*df$Chicken_Egg+0.87*0*df$Duck_Egg
         +0.91*0*df$Pork+0.69*0*df$Pork_Chops+0*df$Beef+0*df$Mutton+0.63*0*df$Chicken
         +0.68*0*df$Duck+0.96*0*df$Pork_Tripe+0*df$Pork_Liver+0.6*0*df$Pork_Trotters
         +0*df$Pork_Blood+0*df$Chicken_Gizzard+0.69*0*df$Chicken_Wings+0.6*0*df$Chicken_Feet
         +0.58*0*df$Grass_Carp+0.61*0*df$Silver_Carp+0.54*0*df$Crucian_Carp+0.58*0*df$Perch
         +0.64*0*df$Yellow_Croaker+0.54*0*df$Eel+0.67*0*df$Sardine+0.63*0*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*0*df$Pomfret+0.76*0*df$Hairtail
         +0.61*0*df$Mandarin_Fish+0.64*0*df$Dike_Fish+0.59*0*df$Bream+0.7*0*df$Horse_Mackerel
         +0.67*0*df$Rice_Eel+0.97*0*df$Squid+0*df$Octopus+0*df$Crab+0.59*0*df$Sea_Shrimp
         +0.41*0*df$Snail+0.39*0*df$Clam+0*df$Oyster+0.57*0*df$Razor_Clam+0.49*0*df$Mussel
         +0*df$Jellyfish+0*df$Fresh_Milk_Boxed_Milk+0*df$Milk_Powder+0*df$Yogurt+0*df$Soy_Milk
         +0*df$Breakfast_Milk_Breakfast_Drink+0.53*10*df$Peanuts+0.745*77.63*df$Other_Nuts+347*df$Soybeans
         +130*df$Mung_Beans+0*df$Soybean_Milk+0*df$Tofu+25*df$Dried_Tofu+280*df$Tofu_Skin+30*df$Tofu_Strips
         +30*df$Fried_Tofu+30*df$Soybean_Sprouts+11*df$Mung_Bean_Sprouts+0.96*200*df$Green_Beans 
         +0.88*480*df$Snow_Peas+0.96*210*df$String_Beans+0.95*0*df$White_Radish+970*df$Carrot_Leaves
         +0.96*4130*df$Carrot+0*df$White_Radish_Leaves+0.88*0*df$Lotus_Root+0.63*0*df$Bamboo_Shoots
         +0.82*11*df$Cauliflower+1141*df$Baby_Bok_Choy+0.94*1853*df$Bokchoy+0.89*80*df$Chinese_Cabbage
         +0.9*20*df$Onion+0.85*30*df$Garlic+0.12*10*df$Water_Bamboo+0.74*2110*df$Amaranth+0.86*12*df$Cabbage
         +0.9*1596*df$Chinese_Chives+1714*df$Water_Spinach+0.89*2920*df$Spinach+0.94*310*df$Mustard_Greens+0.83*0*df$Turnip
         +0.98*0*df$Chinese_Broccoli+0.88*2590*df$Shepherds_Purse+0.67*340*df$Celery+0.96*1460*df$Rapeseed
         +0.94*26*df$Lettuce+0.8*0*df$Winter_Melon+0.92*90*df$Cucumber+0.83*155*df$Luffa
         +0.81*100*df$Bitter_Melon+0.85*890*df$Pumpkin+20*df$Chayote+1149*df$Tomato+0.8*1390*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*98*df$Green_Pepper+20*df$Wood_Ear_Mushroom+30*df$Enoki_Mushroom
         +0.99*10*df$Mushroom+0*df$Shiitake_Mushroom+0.89*123*df$Scallion+0*df$Kelp
         +0.85*50*df$Apple+0.7*36*df$Banana+0.74*160*df$Orange+0.69*10*df$Pomelo+0.82*20*df$Pear
         +0.89*20*df$Peach+0.6*897*df$Mango+0.68*20*df$Pineapple+0.78*30*df$Muskmelon+0.86*40*df$Grape
         +0.92*205*df$Persimmon+0.5*20*df$Longan+0.73*10*df$Lychee+0.62*0*df$Loquat+0.59*173*df$Watermelon
         +0.97*30*df$Strawberry+0.83*130*df$Kiwi+0.69*0*df$Dragon_Fruit+0.78*20*df$Water_Chestnut
         +0.95*20*df$Dried_Shiitake+0.98*240*df$Dried_Kelp+1370*df$Dried_Seaweed+0*df$Dried_Scallop+0*df$Dried_Fish
         +(0*0.45*df$White_Steamed_Bread+0.35*0.91*0*df$Pork+0.89*123*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.89*123*0.05*df$Scallion+0.08*0*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.9*1596*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.89*80*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.1*0.9*1596*df$Chinese_Chives+0.1*0*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Retinol = (0*df$rice+0*df$White_Congee+0*df$Rice_Noodles+0*df$Vermicelli+0*df$Noodles
         +0*df$Macaroni_Pasta+0*df$White_Steamed_Bread +0*df$Oatmeal+0*df$Oil_Cake
         +0*df$Deep_fried_dough_sticks+0*df$Baked_Cake+5*df$Fish_balls+4*df$Cuttlefish_Balls
         +0.86*0*df$Sweet_Potato+0*df$Taro+0.94*0*df$Potato+0.91*0*df$Jicama+0.84*56*df$Salted_Duck_Egg
         +0.9*215*df$Century_Egg+0*df$Pork_Floss+158*df$Ham_Sausage+0.87*216*df$Chicken_Egg+0.87*261*df$Duck_Egg
         +0.91*15*df$Pork+0.69*9.5*df$Pork_Chops+3*df$Beef+8*df$Mutton+0.63*92*df$Chicken
         +0.68*52*df$Duck+0.96*3*df$Pork_Tripe+6502*df$Pork_Liver+0.6*3*df$Pork_Trotters
         +0*df$Pork_Blood+36*df$Chicken_Gizzard+0.69*28*df$Chicken_Wings+0.6*37*df$Chicken_Feet
         +0.58*11*df$Grass_Carp+0.61*20*df$Silver_Carp+0.54*17*df$Crucian_Carp+0.58*19*df$Perch
         +0.64*52*df$Yellow_Croaker+0.54*0*df$Eel+0.67*0*df$Sardine+0.63*42*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*24*df$Pomfret+0.76*29*df$Hairtail
         +0.61*12*df$Mandarin_Fish+0.64*5*df$Dike_Fish+0.59*28*df$Bream+0.7*1*df$Horse_Mackerel
         +0.67*50*df$Rice_Eel+0.97*35*df$Squid+7*df$Octopus+0*df$Crab+0.59*15*df$Sea_Shrimp
         +0.41*26*df$Snail+0.39*21*df$Clam+27*df$Oyster+0.57*59*df$Razor_Clam+0.49*73*df$Mussel
         +14*df$Jellyfish+73*df$Fresh_Milk_Boxed_Milk+163*df$Milk_Powder+23*df$Yogurt+0*df$Soy_Milk
         +113*df$Breakfast_Milk_Breakfast_Drink+0.53*0*df$Peanuts+0.745*0*df$Other_Nuts+0*df$Soybeans
         +0*df$Mung_Beans+0*df$Soybean_Milk+0*df$Tofu+0*df$Dried_Tofu+0*df$Tofu_Skin+0*df$Tofu_Strips
         +0*df$Fried_Tofu+0*df$Soybean_Sprouts+0*df$Mung_Bean_Sprouts+0.96*0*df$Green_Beans 
         +0.88*0*df$Snow_Peas+0.96*0*df$String_Beans+0.95*0*df$White_Radish+0*df$Carrot_Leaves
         +0.96*0*df$Carrot+0*df$White_Radish_Leaves+0.88*0*df$Lotus_Root+0.63*0*df$Bamboo_Shoots
         +0.82*0*df$Cauliflower+0*df$Baby_Bok_Choy+0.94*0*df$Bokchoy+0.89*0*df$Chinese_Cabbage
         +0.9*0*df$Onion+0.85*0*df$Garlic+0.12*0*df$Water_Bamboo+0.74*0*df$Amaranth+0.86*0*df$Cabbage
         +0.9*0*df$Chinese_Chives+0*df$Water_Spinach+0.89*0*df$Spinach+0.94*0*df$Mustard_Greens+0.83*0*df$Turnip
         +0.98*0*df$Chinese_Broccoli+0.88*0*df$Shepherds_Purse+0.67*0*df$Celery+0.96*0*df$Rapeseed
         +0.94*0*df$Lettuce+0.8*0*df$Winter_Melon+0.92*0*df$Cucumber+0.83*0*df$Luffa
         +0.81*0*df$Bitter_Melon+0.85*0*df$Pumpkin+0*df$Chayote+0*df$Tomato+0.8*0*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*0*df$Green_Pepper+0*df$Wood_Ear_Mushroom+0*df$Enoki_Mushroom
         +0.99*0*df$Mushroom+0*df$Shiitake_Mushroom+0.89*0*df$Scallion+0*df$Kelp
         +0.85*0*df$Apple+0.7*0*df$Banana+0.74*0*df$Orange+0.69*0*df$Pomelo+0.82*0*df$Pear
         +0.89*0*df$Peach+0.6*0*df$Mango+0.68*0*df$Pineapple+0.78*0*df$Muskmelon+0.86*0*df$Grape
         +0.92*0*df$Persimmon+0.5*0*df$Longan+0.73*0*df$Lychee+0.62*0*df$Loquat+0.59*0*df$Watermelon
         +0.97*0*df$Strawberry+0.83*0*df$Kiwi+0.69*0*df$Dragon_Fruit+0.78*0*df$Water_Chestnut
         +0.95*0*df$Dried_Shiitake+0.98*0*df$Dried_Kelp+0*df$Dried_Seaweed+11*df$Dried_Scallop+0*df$Dried_Fish
         +(0*0.45*df$White_Steamed_Bread+0.35*0.91*15*df$Pork+0.89*0*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.89*0*0.05*df$Scallion+0.08*0*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.9*0*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.89*7*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*15*df$Pork+0*0.35*df$White_Steamed_Bread+0.1*0.9*0*df$Chinese_Chives+0.1*0.59*15*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$thiamine = (0.02*df$rice+0*df$White_Congee+0.01*df$Rice_Noodles+0.03*df$Vermicelli+0.35*df$Noodles
         +0.12*df$Macaroni_Pasta+0.12*df$White_Steamed_Bread +0.46*df$Oatmeal+0.11*df$Oil_Cake
         +0.01*df$Deep_fried_dough_sticks+0*df$Baked_Cake+0.02*df$Fish_balls+0.01*df$Cuttlefish_Balls
         +0.86*0.07*df$Sweet_Potato+0.06*df$Taro+0.94*0.1*df$Potato+0.91*0.03*df$Jicama+0.84*0.15*df$Salted_Duck_Egg
         +0.9*0.06*df$Century_Egg+0.03*df$Pork_Floss+0.27*df$Ham_Sausage+0.87*0.09*df$Chicken_Egg+0.87*0.17*df$Duck_Egg
         +0.91*0.3*df$Pork+0.69*0.555*df$Pork_Chops+0.04*df$Beef+0.07*df$Mutton+0.63*0.06*df$Chicken
         +0.68*0.08*df$Duck+0.96*0.07*df$Pork_Tripe+0.22*df$Pork_Liver+0.6*0.05*df$Pork_Trotters
         +0.03*df$Pork_Blood+0.04*df$Chicken_Gizzard+0.69*0*df$Chicken_Wings+0.6*0.01*df$Chicken_Feet
         +0.58*0.04*df$Grass_Carp+0.61*0.03*df$Silver_Carp+0.54*0.04*df$Crucian_Carp+0.58*0.03*df$Perch
         +0.64*0.03*df$Yellow_Croaker+0.54*0.02*df$Eel+0.67*0.01*df$Sardine+0.63*0.03*df$Black_Carp 
         +0.49*0.03*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*0.04*df$Pomfret+0.76*0.02*df$Hairtail
         +0.61*0.02*df$Mandarin_Fish+0.64*0.19*df$Dike_Fish+0.59*0.02*df$Bream+0.7*0.06*df$Horse_Mackerel
         +0.67*0.06*df$Rice_Eel+0.97*0.02*df$Squid+0.07*df$Octopus+0.03*df$Crab+0.59*0*df$Sea_Shrimp
         +0.41*0.03*df$Snail+0.39*0.01*df$Clam+0.01*df$Oyster+0.57*0.02*df$Razor_Clam+0.49*0.12*df$Mussel
         +0.05*df$Jellyfish+0.02*df$Fresh_Milk_Boxed_Milk+0.13*df$Milk_Powder+0.03*df$Yogurt+0.02*df$Soy_Milk
         +0.02*df$Breakfast_Milk_Breakfast_Drink+0.53*0*df$Peanuts+0.745*0.25*df$Other_Nuts+0.34*df$Soybeans
         +0.25*df$Mung_Beans+0.02*df$Soybean_Milk+0.06*df$Tofu+0.02*df$Dried_Tofu+0.22*df$Tofu_Skin+0.04*df$Tofu_Strips
         +0.02*df$Fried_Tofu+0.05*df$Soybean_Sprouts+0.09*df$Mung_Bean_Sprouts+0.96*0.04*df$Green_Beans 
         +0.88*0.02*df$Snow_Peas+0.96*0.02*df$String_Beans+0.95*0.02*df$White_Radish+0.04*df$Carrot_Leaves
         +0.96*0.04*df$Carrot+0.02*df$White_Radish_Leaves+0.88*0.04*df$Lotus_Root+0.63*0.08*df$Bamboo_Shoots
         +0.82*0.04*df$Cauliflower+0.02*df$Baby_Bok_Choy+0.94*0.01*df$Bokchoy+0.89*0.05*df$Chinese_Cabbage
         +0.9*0.03*df$Onion+0.85*0.04*df$Garlic+0.12*0.03*df$Water_Bamboo+0.74*0.03*df$Amaranth+0.86*0.02*df$Cabbage
         +0.9*0.04*df$Chinese_Chives+0.03*df$Water_Spinach+0.89*0.04*df$Spinach+0.94*0.03*df$Mustard_Greens+0.83*0.06*df$Turnip
         +0.98*0.03*df$Chinese_Broccoli+0.88*0.04*df$Shepherds_Purse+0.67*0.02*df$Celery+0.96*0.01*df$Rapeseed
         +0.94*0.02*df$Lettuce+0.8*0*df$Winter_Melon+0.92*0.02*df$Cucumber+0.83*0.02*df$Luffa
         +0.81*0.03*df$Bitter_Melon+0.85*0.03*df$Pumpkin+0.01*df$Chayote+0.03*df$Tomato+0.8*0.03*df$Chili_Pepper
         +0.95*0.02*df$Eggplant+0.91*0.01*df$Green_Pepper+0.15*df$Wood_Ear_Mushroom+0.08*df$Enoki_Mushroom
         +0.99*0*df$Mushroom+0.03*df$Shiitake_Mushroom+0.89*0.02*df$Scallion+0.02*df$Kelp
         +0.85*0.02*df$Apple+0.7*0.02*df$Banana+0.74*0.05*df$Orange+0.69*0*df$Pomelo+0.82*0.03*df$Pear
         +0.89*0.01*df$Peach+0.6*0.01*df$Mango+0.68*0.04*df$Pineapple+0.78*0.02*df$Muskmelon+0.86*0.03*df$Grape
         +0.92*0.015*df$Persimmon+0.5*0.01*df$Longan+0.73*0.1*df$Lychee+0.62*0.01*df$Loquat+0.59*0.02*df$Watermelon
         +0.97*0.02*df$Strawberry+0.83*0.05*df$Kiwi+0.69*0.03*df$Dragon_Fruit+0.78*0.02*df$Water_Chestnut
         +0.95*0.19*df$Dried_Shiitake+0.98*0.01*df$Dried_Kelp+0.27*df$Dried_Seaweed+0*df$Dried_Scallop+0.11*df$Dried_Fish
         +(0.12*0.45*df$White_Steamed_Bread+0.35*0.91*0.3*df$Pork+0.89*0.02*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0.3*df$Pork+0.12*0.35*df$White_Steamed_Bread+0.89*0.02*0.05*df$Scallion+0.03*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0.3*df$Pork+0.12*0.35*df$White_Steamed_Bread+0.15*0.9*0.04*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0.3*df$Pork+0.12*0.35*df$White_Steamed_Bread+0.15*0.89*0.05*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0.3*df$Pork+0.12*0.35*df$White_Steamed_Bread+0.1*0.9*0.04*df$Chinese_Chives+0.1*0.59*0*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$riboflavin = (0.03*df$rice+0.03*df$White_Congee+0.01*df$Rice_Noodles+0.02*df$Vermicelli+0.1*df$Noodles
         +0.03*df$Macaroni_Pasta+0.02*df$White_Steamed_Bread +0.07*df$Oatmeal+0.05*df$Oil_Cake
         +0.07*df$Deep_fried_dough_sticks+0.01*df$Baked_Cake+0.04*df$Fish_balls+0.03*df$Cuttlefish_Balls
         +0.86*0.04*df$Sweet_Potato+0.03*df$Taro+0.94*0.02*df$Potato+0.91*0.03*df$Jicama+0.84*0.28*df$Salted_Duck_Egg
         +0.9*0.18*df$Century_Egg+0.19*df$Pork_Floss+0.14*df$Ham_Sausage+0.87*0.20*df$Chicken_Egg+0.87*0.35*df$Duck_Egg
         +0.91*0.13*df$Pork+0.69*0.205*df$Pork_Chops+0.11*df$Beef+0.16*df$Mutton+0.63*0.07*df$Chicken
         +0.68*0.22*df$Duck+0.96*0.16*df$Pork_Tripe+2.02*df$Pork_Liver+0.6*0.1*df$Pork_Trotters
         +0.04*df$Pork_Blood+0.09*df$Chicken_Gizzard+0.69*0.05*df$Chicken_Wings+0.6*0.13*df$Chicken_Feet
         +0.58*0.11*df$Grass_Carp+0.61*0.07*df$Silver_Carp+0.54*0.09*df$Crucian_Carp+0.58*0.17*df$Perch
         +0.64*0.09*df$Yellow_Croaker+0.54*0.02*df$Eel+0.67*0.03*df$Sardine+0.63*0.07*df$Black_Carp 
         +0.49*0.47*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*0.07*df$Pomfret+0.76*0.06*df$Hairtail
         +0.61*0.07*df$Mandarin_Fish+0.64*0.12*df$Dike_Fish+0.59*0.07*df$Bream+0.7*0.11*df$Horse_Mackerel
         +0.67*0.98*df$Rice_Eel+0.97*0.06*df$Squid+0.13*df$Octopus+0.03*df$Crab+0.89*0.04**df$Sea_Shrimp
         +0.41*0.4*df$Snail+0.39*0.13*df$Clam+0.13*df$Oyster+0.57*0.12*df$Razor_Clam+0.49*0.22*df$Mussel
         +0.045*df$Jellyfish+0.12*df$Fresh_Milk_Boxed_Milk+1.9*df$Milk_Powder+0.12*df$Yogurt+0.06*df$Soy_Milk
         +0.11*df$Breakfast_Milk_Breakfast_Drink+0.53*0.04*df$Peanuts+0.745*0.25*df$Other_Nuts+0.24*df$Soybeans
         +0.11*df$Mung_Beans+0.02*df$Soybean_Milk+0.02*df$Tofu+0.05*df$Dried_Tofu+0.12*df$Tofu_Skin+0.12*df$Tofu_Strips
         +0.04*df$Fried_Tofu+0.07*df$Soybean_Sprouts+0.02*df$Mung_Bean_Sprouts+0.96*0.07*df$Green_Beans 
         +0.88*0.04*df$Snow_Peas+0.96*0.07*df$String_Beans+0.95*0.01*df$White_Radish+0*df$Carrot_Leaves
         +0.96*0.03*df$Carrot+0*df$White_Radish_Leaves+0.88*0.01*df$Lotus_Root+0.63*0.08*df$Bamboo_Shoots
         +0.82*0.04*df$Cauliflower+0.10*df$Baby_Bok_Choy+0.94*0.05*df$Bokchoy+0.89*0.04*df$Chinese_Cabbage
         +0.9*0.03*df$Onion+0.85*0.06*df$Garlic+0.12*0.04*df$Water_Bamboo+0.74*0.12*df$Amaranth+0.86*0.02*df$Cabbage
         +0.9*0.05*df$Chinese_Chives+0.05*df$Water_Spinach+0.89*0.11*df$Spinach+0.94*0.11*df$Mustard_Greens+0.83*0.02*df$Turnip
         +0.98*0.12*df$Chinese_Broccoli+0.88*0.15*df$Shepherds_Purse+0.67*0.06*df$Celery+0.96*0.10*df$Rapeseed
         +0.94*0.01*df$Lettuce+0.8*0*df$Winter_Melon+0.92*0.03*df$Cucumber+0.83*0.04*df$Luffa
         +0.81*0.03*df$Bitter_Melon+0.85*0.04*df$Pumpkin+0.10*df$Chayote+0.02*df$Tomato+0.8*0.06*df$Chili_Pepper
         +0.95*0.03*df$Eggplant+0.91*0.02*df$Green_Pepper+0.05*df$Wood_Ear_Mushroom+0.19*df$Enoki_Mushroom
         +0.99*0.35*df$Mushroom+0.08*df$Shiitake_Mushroom+0.89*0.05*df$Scallion+0.15*df$Kelp
         +0.85*0.02*df$Apple+0.7*0.02*df$Banana+0.74*0.04*df$Orange+0.69*0.03*df$Pomelo+0.82*0.03*df$Pear
         +0.89*0.02*df$Peach+0.6*0.04*df$Mango+0.68*0.02*df$Pineapple+0.78*0.03*df$Muskmelon+0.86*0.02*df$Grape
         +0.92*0.02*df$Persimmon+0.5*0.14*df$Longan+0.73*0.04*df$Lychee+0.62*0.03*df$Loquat+0.59*0.04*df$Watermelon
         +0.97*0.03*df$Strawberry+0.83*0.02*df$Kiwi+0.69*0.02*df$Dragon_Fruit+0.78*0.02*df$Water_Chestnut
         +0.95*1.26*df$Dried_Shiitake+0.98*0.10*df$Dried_Kelp+1.02*df$Dried_Seaweed+0.21*df$Dried_Scallop+0.39*df$Dried_Fish
         +(0.02*0.45*df$White_Steamed_Bread+0.35*0.91*0.13*df$Pork+0.89*0.05*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0.13**df$Pork+0.02*0.35*df$White_Steamed_Bread+0.89*0.05*0.05*df$Scallion+0.08*0.08*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0.13*df$Pork+0.02*0.35*df$White_Steamed_Bread+0.15*0.9*0.05*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0.13*df$Pork+0.02*0.35*df$White_Steamed_Bread+0.15*0.89*0.04*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0.13*df$Pork+0.02*0.35*df$White_Steamed_Bread+0.1*0.9*0.05*df$Chinese_Chives+0.1*0.59*0*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$niacin = (1.90*df$rice+0.2*df$White_Congee+0*df$Rice_Noodles+0.4*df$Vermicelli+3.1*df$Noodles
         +1*df$Macaroni_Pasta+0.79*df$White_Steamed_Bread +0*df$Oatmeal+0*df$Oil_Cake
         +0.7*df$Deep_fried_dough_sticks+1.1*df$Baked_Cake+0*df$Fish_balls+0.86*df$Cuttlefish_Balls
         +0.86*0.6*df$Sweet_Potato+0.5*df$Taro+0.94*1.1*df$Potato+0.91*0.30*df$Jicama+0.84*0.04*df$Salted_Duck_Egg
         +0.9*0.1*df$Century_Egg+2.7*df$Pork_Floss+2.6*df$Ham_Sausage+0.87*0.20*df$Chicken_Egg+0.87*0.20*df$Duck_Egg
         +0.91*4.1*df$Pork+0.69*4.705*df$Pork_Chops+4.15*df$Beef+4.41*df$Mutton+0.63*7.54*df$Chicken
         +0.68*4.2*df$Duck+0.96*3.7*df$Pork_Tripe+10.11*df$Pork_Liver+0.6*1.5*df$Pork_Trotters
         +0.3*df$Pork_Blood+3.4*df$Chicken_Gizzard+0.69*4.36*df$Chicken_Wings+0.6*2.4*df$Chicken_Feet
         +0.58*2.8*df$Grass_Carp+0.61*2.5*df$Silver_Carp+0.54*2.5*df$Crucian_Carp+0.58*3.1*df$Perch
         +0.64*1.31*df$Yellow_Croaker+0.54*3.8*df$Eel+0.67*2*df$Sardine+0.63*2.9*df$Black_Carp 
         +0.49*6.05*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*2.1*df$Pomfret+0.76*2.8*df$Hairtail
         +0.61*5.9*df$Mandarin_Fish+0.64*6.5*df$Dike_Fish+0.59*1.7*df$Bream+0.7*3.6*df$Horse_Mackerel
         +0.67*3.7*df$Rice_Eel+0.97*1.6*df$Squid+1.4*df$Octopus+4.3*df$Crab+0.89*2.4**df$Sea_Shrimp
         +0.41*1.8*df$Snail+0.39*1.5*df$Clam+1.4*df$Oyster+0.57*1.2*df$Razor_Clam+0.49*1.8*df$Mussel
         +0.25*df$Jellyfish+0*df$Fresh_Milk_Boxed_Milk+0.5*df$Milk_Powder+0.09*df$Yogurt+0.3*df$Soy_Milk
         +0*df$Breakfast_Milk_Breakfast_Drink+0.53*14.1*df$Peanuts+0.745*4.04*df$Other_Nuts+2.37*df$Soybeans
         +2*df$Mung_Beans+0.14*df$Soybean_Milk+0.21*df$Tofu+0.4*df$Dried_Tofu+0.91*df$Tofu_Skin+0.50*df$Tofu_Strips
         +0.3*df$Fried_Tofu+0.6*df$Soybean_Sprouts+0.35*df$Mung_Bean_Sprouts+0.96*0.9*df$Green_Beans 
         +0.88*0.7*df$Snow_Peas+0.96*0.4*df$String_Beans+0.95*0.14*df$White_Radish+0*df$Carrot_Leaves
         +0.96*0.6*df$Carrot+0*df$White_Radish_Leaves+0.88*0.12*df$Lotus_Root+0.63*0.6*df$Bamboo_Shoots
         +0.82*0.32*df$Cauliflower+0.59*df$Baby_Bok_Choy+0.94*0*df$Bokchoy+0.89*0.65*df$Chinese_Cabbage
         +0.9*0.3*df$Onion+0.85*0.6*df$Garlic+0.12*0.5*df$Water_Bamboo+0.74*0.8*df$Amaranth+0.86*0.24*df$Cabbage
         +0.9*0.86*df$Chinese_Chives+0.22*df$Water_Spinach+0.89*0.6*df$Spinach+0.94*0.5*df$Mustard_Greens+0.83*0.6*df$Turnip
         +0.98*0.68*df$Chinese_Broccoli+0.88*0.6*df$Shepherds_Purse+0.67*0.4*df$Celery+0.96*0*df$Rapeseed
         +0.94*0*df$Lettuce+0.8*0.22*df$Winter_Melon+0.92*0.2*df$Cucumber+0.83*0.32*df$Luffa
         +0.81*0.4*df$Bitter_Melon+0.85*0.4*df$Pumpkin+0.10*df$Chayote+0.8*df$Tomato+0.8*0.8*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*0.62*df$Green_Pepper+0.20*df$Wood_Ear_Mushroom+4.1*df$Enoki_Mushroom
         +0.99*4*df$Mushroom+2*df$Shiitake_Mushroom+0.89*0.49*df$Scallion+1.3*df$Kelp
         +0.85*0.2*df$Apple+0.7*0.51*df$Banana+0.74*0.3*df$Orange+0.69*0.3*df$Pomelo+0.82*0.2*df$Pear
         +0.89*0.3*df$Peach+0.6*0.3*df$Mango+0.68*0.2*df$Pineapple+0.78*0.3*df$Muskmelon+0.86*0.25*df$Grape
         +0.92*0.4*df$Persimmon+0.5*1.3*df$Longan+0.73*1.1*df$Lychee+0.62*0.3*df$Loquat+0.59*0.3*df$Watermelon
         +0.97*0.3*df$Strawberry+0.83*0.3*df$Kiwi+0.69*0.22*df$Dragon_Fruit+0.78*0.7*df$Water_Chestnut
         +0.95*20.5*df$Dried_Shiitake+0.98*0.8*df$Dried_Kelp+7.3*df$Dried_Seaweed+2.5*df$Dried_Scallop+5*df$Dried_Fish
         +(0.79*0.45*df$White_Steamed_Bread+0.35*0.91*0.13*df$Pork+0.89*0.49*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*4.1*df$Pork+0.79*0.35*df$White_Steamed_Bread+0.89*0.49*0.05*df$Scallion+0.08*2*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*4.1*df$Pork+0.79*0.35*df$White_Steamed_Bread+0.15*0.9*0.86*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*4.1*df$Pork+0.79*0.35*df$White_Steamed_Bread+0.15*0.89*0.65*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*4.1*df$Pork+0.79*0.35*df$White_Steamed_Bread+0.1*0.9*0.86*df$Chinese_Chives+0.1*0.59*0*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$vitmain_c = (0*df$rice+0*df$White_Congee+0*df$Rice_Noodles+0*df$Vermicelli+0*df$Noodles
         +0*df$Macaroni_Pasta+0*df$White_Steamed_Bread +0*df$Oatmeal+0*df$Oil_Cake
         +0*df$Deep_fried_dough_sticks+0*df$Baked_Cake+0*df$Fish_balls+0*df$Cuttlefish_Balls
         +0.86*24*df$Sweet_Potato+0*df$Taro+0.94*14*df$Potato+0.91*13*df$Jicama+0.84*0*df$Salted_Duck_Egg
         +0.9*0*df$Century_Egg+0*df$Pork_Floss+0*df$Ham_Sausage+0.87*0*df$Chicken_Egg+0.87*0*df$Duck_Egg
         +0.91*0*df$Pork+0.69*0*df$Pork_Chops+0*df$Beef+0*df$Mutton+0.63*0*df$Chicken
         +0.68*0*df$Duck+0.96*0*df$Pork_Tripe+20*df$Pork_Liver+0.6*0*df$Pork_Trotters
         +0*df$Pork_Blood+0*df$Chicken_Gizzard+0.69*0*df$Chicken_Wings+0.6*0*df$Chicken_Feet
         +0.58*0*df$Grass_Carp+0.61*0*df$Silver_Carp+0.54*0*df$Crucian_Carp+0.58*0*df$Perch
         +0.64*0*df$Yellow_Croaker+0.54*0*df$Eel+0.67*0*df$Sardine+0.63*0*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*0*df$Pomfret+0.76*0*df$Hairtail
         +0.61*0*df$Mandarin_Fish+0.64*0*df$Dike_Fish+0.59*0*df$Bream+0.7*0*df$Horse_Mackerel
         +0.67*0*df$Rice_Eel+0.97*0*df$Squid+0*df$Octopus+0*df$Crab+0.59*0*df$Sea_Shrimp
         +0.41*0*df$Snail+0.39*0*df$Clam+0*df$Oyster+0.57*0*df$Razor_Clam+0.49*0*df$Mussel
         +0*df$Jellyfish+0*df$Fresh_Milk_Boxed_Milk+23.6*df$Milk_Powder+1.3*df$Yogurt+0*df$Soy_Milk
         +0*df$Breakfast_Milk_Breakfast_Drink+0.53*14*df$Peanuts+0.745*18.2*df$Other_Nuts+29*df$Soybeans
         +11*df$Mung_Beans+0*df$Soybean_Milk+0*df$Tofu+2*df$Dried_Tofu+23*df$Tofu_Skin+3*df$Tofu_Strips
         +3*df$Fried_Tofu+8*df$Soybean_Sprouts+4*df$Mung_Bean_Sprouts+0.96*18*df$Green_Beans 
         +0.88*16*df$Snow_Peas+0.96*6*df$String_Beans+0.95*19*df$White_Radish+41*df$Carrot_Leaves
         +0.96*77*df$Carrot+13*df$White_Radish_Leaves+0.88*19*df$Lotus_Root+0.63*5*df$Bamboo_Shoots
         +0.82*32*df$Cauliflower+37.4*df$Baby_Bok_Choy+0.94*64*df$Bokchoy+0.89*37.5*df$Chinese_Cabbage
         +0.9*8*df$Onion+0.85*7*df$Garlic+0.12*6*df$Water_Bamboo+0.74*47*df$Amaranth+0.86*16*df$Cabbage
         +0.9*2*df$Chinese_Chives+5*df$Water_Spinach+0.89*31*df$Spinach+0.94*34*df$Mustard_Greens+0.83*37*df$Turnip
         +0.98*43*df$Chinese_Broccoli+0.88*8*df$Shepherds_Purse+0.67*24*df$Celery+0.96*0*df$Rapeseed
         +0.94*16*df$Lettuce+0.8*16*df$Winter_Melon+0.92*9*df$Cucumber+0.83*4*df$Luffa
         +0.81*56*df$Bitter_Melon+0.85*8*df$Pumpkin+8*df$Chayote+5*df$Tomato+0.8*144*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*59*df$Green_Pepper+1*df$Wood_Ear_Mushroom+2*df$Enoki_Mushroom
         +0.99*2*df$Mushroom+1*df$Shiitake_Mushroom+0.89*9*df$Scallion+0*df$Kelp
         +0.85*3*df$Apple+0.7*4.9*df$Banana+0.74*33*df$Orange+0.69*23*df$Pomelo+0.82*5*df$Pear
         +0.89*10*df$Peach+0.6*23*df$Mango+0.68*18*df$Pineapple+0.78*15*df$Muskmelon+0.86*4*df$Grape
         +0.92*30*df$Persimmon+0.5*43*df$Longan+0.73*41*df$Lychee+0.62*8*df$Loquat+0.59*5.7*df$Watermelon
         +0.97*47*df$Strawberry+0.83*62*df$Kiwi+0.69*3*df$Dragon_Fruit+0.78*7*df$Water_Chestnut
         +0.95*5*df$Dried_Shiitake+0.98*0*df$Dried_Kelp+2*df$Dried_Seaweed+0*df$Dried_Scallop+0*df$Dried_Fish
         +(0*0.45*df$White_Steamed_Bread+0.35*0.91*0*df$Pork+0.89*9*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.89*9*0.05*df$Scallion+0.08*1*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.9*2*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.89*37.5*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0*df$Pork+0*0.35*df$White_Steamed_Bread+0.1*0.9*2*df$Chinese_Chives+0.1*0.59*0*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$vitmain_e = (0*df$rice+0*df$White_Congee+0*df$Rice_Noodles+0*df$Vermicelli+0.47*df$Noodles
         +0*df$Macaroni_Pasta+0*df$White_Steamed_Bread +0.91*df$Oatmeal+13.72*df$Oil_Cake
         +3.19*df$Deep_fried_dough_sticks+0.39*df$Baked_Cake+0.14*df$Fish_balls+0.5*df$Cuttlefish_Balls
         +0.86*0.43*df$Sweet_Potato+0*df$Taro+0.94*0.34*df$Potato+0.91*0.86*df$Jicama+0.84*2.85*df$Salted_Duck_Egg
         +0.9*3.05*df$Century_Egg+0.78*df$Pork_Floss+0.17*df$Ham_Sausage+0.87*1.17*df$Chicken_Egg+0.87*4.98*df$Duck_Egg
         +0.91*0.67*df$Pork+0.69*0.285*df$Pork_Chops+0.68*df$Beef+0.48*df$Mutton+0.63*1.34*df$Chicken
         +0.68*0.27*df$Duck+0.96*0.32*df$Pork_Tripe+0*df$Pork_Liver+0.6*0.01*df$Pork_Trotters
         +0.2*df$Pork_Blood+0.87*df$Chicken_Gizzard+0.69*0.44*df$Chicken_Wings+0.6*0.32*df$Chicken_Feet
         +0.58*2.03*df$Grass_Carp+0.61*1.23*df$Silver_Carp+0.54*0.68*df$Crucian_Carp+0.58*0.75*df$Perch
         +0.64*0.0975*df$Yellow_Croaker+0.54*3.6*df$Eel+0.67*0.26*df$Sardine+0.63*0.81*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*13.17*df$Spanish_Mackerel+0.7*1.26*df$Pomfret+0.76*0.82*df$Hairtail
         +0.61*0.87*df$Mandarin_Fish+0.64*0.33*df$Dike_Fish+0.59*0.52*df$Bream+0.7*0.49*df$Horse_Mackerel
         +0.67*1.34*df$Rice_Eel+0.97*1.68*df$Squid+0.16*df$Octopus+2.91*df$Crab+0.59*1.64*df$Sea_Shrimp
         +0.41*7.58*df$Snail+0.39*2.41*df$Clam+0.81*df$Oyster+0.57*0.59*df$Razor_Clam+0.49*14.02*df$Mussel
         +2.475*df$Jellyfish+0.11*df$Fresh_Milk_Boxed_Milk+0.48*df$Milk_Powder+0.12*df$Yogurt+4.5*df$Soy_Milk
         +0.07*df$Breakfast_Milk_Breakfast_Drink+0.53*2.93*df$Peanuts+0.745*22.81*df$Other_Nuts+15.45*df$Soybeans
         +10.95*df$Mung_Beans+1.06*df$Soybean_Milk+5.79*df$Tofu+13*df$Dried_Tofu+46.55*df$Tofu_Skin+9.76*df$Tofu_Strips
         +24.7*df$Fried_Tofu+0.8*df$Soybean_Sprouts+0*df$Mung_Bean_Sprouts+0.96*2.24*df$Green_Beans 
         +0.88*0.3*df$Snow_Peas+0.96*1.24*df$String_Beans+0.95*0*df$White_Radish+0.41*df$Carrot_Leaves
         +0.96*0*df$Carrot+0*df$White_Radish_Leaves+0.88*0.32*df$Lotus_Root+0.63*0.05*df$Bamboo_Shoots
         +0.82*0*df$Cauliflower+0.16*df$Baby_Bok_Choy+0.94*0.4*df$Bokchoy+0.89*0.36*df$Chinese_Cabbage
         +0.9*0.14*df$Onion+0.85*1.07*df$Garlic+0.12*0*df$Water_Bamboo+0.74*0.36*df$Amaranth+0.86*0*df$Cabbage
         +0.9*0.57*df$Chinese_Chives+0.1*df$Water_Spinach+0.89*1.74*df$Spinach+0.94*0.74*df$Mustard_Greens+0.83*0.2*df$Turnip
         +0.98*0*df$Chinese_Broccoli+0.88*1.01*df$Shepherds_Purse+0.67*1.32*df$Celery+0.96*0.94*df$Rapeseed
         +0.94*0*df$Lettuce+0.8*0.04*df$Winter_Melon+0.92*0.49*df$Cucumber+0.83*0.08*df$Luffa
         +0.81*0.85*df$Bitter_Melon+0.85*0.36*df$Pumpkin+0*df$Chayote+1.66*df$Tomato+0.8*0.44*df$Chili_Pepper
         +0.95*0*df$Eggplant+0.91*0.38*df$Green_Pepper+0*df$Wood_Ear_Mushroom+1.14*df$Enoki_Mushroom
         +0.99*0.56*df$Mushroom+0*df$Shiitake_Mushroom+0.89*0.18*df$Scallion+1.85*df$Kelp
         +0.85*0.43*df$Apple+0.7*0.2*df$Banana+0.74*0.56*df$Orange+0.69*0*df$Pomelo+0.82*0.46*df$Pear
         +0.89*0.71*df$Peach+0.6*1.21*df$Mango+0.68*0*df$Pineapple+0.78*0.47*df$Muskmelon+0.86*0.86*df$Grape
         +0.92*0.875*df$Persimmon+0.5*0*df$Longan+0.73*0*df$Lychee+0.62*0.24*df$Loquat+0.59*0.11*df$Watermelon
         +0.97*0.71*df$Strawberry+0.83*2.43*df$Kiwi+0.69*0.14*df$Dragon_Fruit+0.78*0.65*df$Water_Chestnut
         +0.95*0.66*df$Dried_Shiitake+0.98*0.85*df$Dried_Kelp+1.82*df$Dried_Seaweed+1.53*df$Dried_Scallop+0.88*df$Dried_Fish
         +(0*0.45*df$White_Steamed_Bread+0.35*0.91*0.67*df$Pork+0.89*0.18*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0.67*df$Pork+0*0.35*df$White_Steamed_Bread+0.89*0.18*0.05*df$Scallion+0.08*0*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0.67*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.9*0.57*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0.67*df$Pork+0*0.35*df$White_Steamed_Bread+0.15*0.89*0.36*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0.67*df$Pork+0*0.35*df$White_Steamed_Bread+0.1*0.9*0.57*df$Chinese_Chives+0.1*0.59*1.64*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Ca = (7*df$rice+7*df$White_Congee+11*df$Rice_Noodles+31*df$Vermicelli+13*df$Noodles
         +14*df$Macaroni_Pasta+58*df$White_Steamed_Bread +58*df$Oatmeal+46*df$Oil_Cake
         +6*df$Deep_fried_dough_sticks+51*df$Baked_Cake+97*df$Fish_balls+24*df$Cuttlefish_Balls
         +0.86*24*df$Sweet_Potato+16*df$Taro+0.94*7*df$Potato+0.91*21*df$Jicama+0.84*52*df$Salted_Duck_Egg
         +0.9*63*df$Century_Egg+3*df$Pork_Floss+10*df$Ham_Sausage+0.87*56*df$Chicken_Egg+0.87*62*df$Duck_Egg
         +0.91*6*df$Pork+0.69*11*df$Pork_Chops+5*df$Beef+16*df$Mutton+0.63*13*df$Chicken
         +0.68*6*df$Duck+0.96*11*df$Pork_Tripe+6*df$Pork_Liver+0.6*33*df$Pork_Trotters
         +4*df$Pork_Blood+7*df$Chicken_Gizzard+0.69*8*df$Chicken_Wings+0.6*36*df$Chicken_Feet
         +0.58*38*df$Grass_Carp+0.61*53*df$Silver_Carp+0.54*79*df$Crucian_Carp+0.58*138*df$Perch
         +0.64*122*df$Yellow_Croaker+0.54*42*df$Eel+0.67*184*df$Sardine+0.63*31*df$Black_Carp 
         +0.49*7*df$Mackerel+0.72*11*df$Spanish_Mackerel+0.7*46*df$Pomfret+0.76*28*df$Hairtail
         +0.61*63*df$Mandarin_Fish+0.64*15*df$Dike_Fish+0.59*89*df$Bream+0.7*55*df$Horse_Mackerel
         +0.67*42*df$Rice_Eel+0.97*44*df$Squid+22*df$Octopus+231*df$Crab+0.59*59*df$Sea_Shrimp
         +0.41*722*df$Snail+0.39*133*df$Clam+131*df$Oyster+0.57*134*df$Razor_Clam+0.49*63*df$Mussel
         +135*df$Jellyfish+113*df$Fresh_Milk_Boxed_Milk+928*df$Milk_Powder+128*df$Yogurt+23*df$Soy_Milk
         +105*df$Breakfast_Milk_Breakfast_Drink+0.53*8*df$Peanuts+0.745*123.33*df$Other_Nuts+205*df$Soybeans
         +81*df$Mung_Beans+5*df$Soybean_Milk+78*df$Tofu+447*df$Dried_Tofu+239*df$Tofu_Skin+204*df$Tofu_Strips
         +147*df$Fried_Tofu+21*df$Soybean_Sprouts+14*df$Mung_Bean_Sprouts+0.96*29*df$Green_Beans 
         +0.88*51*df$Snow_Peas+0.96*42*df$String_Beans+0.95*47*df$White_Radish+350*df$Carrot_Leaves
         +0.96*32*df$Carrot+0*df$White_Radish_Leaves+0.88*18*df$Lotus_Root+0.63*9*df$Bamboo_Shoots
         +0.82*31*df$Cauliflower+66*df$Baby_Bok_Choy+0.94*117*df$Bokchoy+0.89*57*df$Chinese_Cabbage
         +0.9*24*df$Onion+0.85*39*df$Garlic+0.12*53*df$Water_Bamboo+0.74*187*df$Amaranth+0.86*28*df$Cabbage
         +0.9*44*df$Chinese_Chives+115*df$Water_Spinach+0.89*66*df$Spinach+0.94*230*df$Mustard_Greens+0.83*65*df$Turnip
         +0.98*121*df$Chinese_Broccoli+0.88*294*df$Shepherds_Purse+0.67*80*df$Celery+0.96*191*df$Rapeseed
         +0.94*14*df$Lettuce+0.8*12*df$Winter_Melon+0.92*24*df$Cucumber+0.83*37*df$Luffa
         +0.81*14*df$Bitter_Melon+0.85*16*df$Pumpkin+17*df$Chayote+31*df$Tomato+0.8*37*df$Chili_Pepper
         +0.95*50*df$Eggplant+0.91*11*df$Green_Pepper+34*df$Wood_Ear_Mushroom+0*df$Enoki_Mushroom
         +0.99*6*df$Mushroom+2*df$Shiitake_Mushroom+0.89*72*df$Scallion+46*df$Kelp
         +0.85*4*df$Apple+0.7*9*df$Banana+0.74*20*df$Orange+0.69*4*df$Pomelo+0.82*7*df$Pear
         +0.89*6*df$Peach+0.6*0*df$Mango+0.68*12*df$Pineapple+0.78*14*df$Muskmelon+0.86*9*df$Grape
         +0.92*31.5*df$Persimmon+0.5*6*df$Longan+0.73*2*df$Lychee+0.62*17*df$Loquat+0.59*7*df$Watermelon
         +0.97*18*df$Strawberry+0.83*27*df$Kiwi+0.69*7*df$Dragon_Fruit+0.78*4*df$Water_Chestnut
         +0.95*83*df$Dried_Shiitake+0.98*348*df$Dried_Kelp+264*df$Dried_Seaweed+77*df$Dried_Scallop+106*df$Dried_Fish
         +(58*0.45*df$White_Steamed_Bread+0.35*0.91*6*df$Pork+0.89*72*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*6*df$Pork+58*0.35*df$White_Steamed_Bread+0.89*72*0.05*df$Scallion+0.08*2*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*6*df$Pork+58*0.35*df$White_Steamed_Bread+0.15*0.9*44*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*6*df$Pork+58*0.35*df$White_Steamed_Bread+0.15*0.89*57*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*6*df$Pork+58*0.35*df$White_Steamed_Bread+0.1*0.9*44*df$Chinese_Chives+0.1*0.59*59*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$P = (62*df$rice+20*df$White_Congee+45*df$Rice_Noodles+16*df$Vermicelli+142*df$Noodles
         +97*df$Macaroni_Pasta+43*df$White_Steamed_Bread +342*df$Oatmeal+124*df$Oil_Cake
         +77*df$Deep_fried_dough_sticks+105*df$Baked_Cake+272*df$Fish_balls+120*df$Cuttlefish_Balls
         +0.86*46*df$Sweet_Potato+58*df$Taro+0.94*46*df$Potato+0.91*24*df$Jicama+0.84*212*df$Salted_Duck_Egg
         +0.9*165*df$Century_Egg+151*df$Pork_Floss+161*df$Ham_Sausage+0.87*130*df$Chicken_Egg+0.87*226*df$Duck_Egg
         +0.91*121*df$Pork+0.69*113*df$Pork_Chops+182*df$Beef+161*df$Mutton+0.63*166*df$Chicken
         +0.68*122*df$Duck+0.96*124*df$Pork_Tripe+243*df$Pork_Liver+0.6*33*df$Pork_Trotters
         +16*df$Pork_Blood+135*df$Chicken_Gizzard+0.69*94*df$Chicken_Wings+0.6*76*df$Chicken_Feet
         +0.58*203*df$Grass_Carp+0.61*190*df$Silver_Carp+0.54*193*df$Crucian_Carp+0.58*242*df$Perch
         +0.64*195.5*df$Yellow_Croaker+0.54*248*df$Eel+0.67*183*df$Sardine+0.63*184*df$Black_Carp 
         +0.49*160*df$Mackerel+0.72*290*df$Spanish_Mackerel+0.7*155*df$Pomfret+0.76*191*df$Hairtail
         +0.61*217*df$Mandarin_Fish+0.64*324*df$Dike_Fish+0.59*188*df$Bream+0.7*191*df$Horse_Mackerel
         +0.67*206*df$Rice_Eel+0.97*19*df$Squid+106*df$Octopus+159*df$Crab+0.59*275*df$Sea_Shrimp
         +0.41*118*df$Snail+0.39*128*df$Clam+115*df$Oyster+0.57*114*df$Razor_Clam+0.49*197*df$Mussel
         +26*df$Jellyfish+103*df$Fresh_Milk_Boxed_Milk+513*df$Milk_Powder+76*df$Yogurt+35*df$Soy_Milk
         +89*df$Breakfast_Milk_Breakfast_Drink+0.53*250*df$Peanuts+0.745*402.75*df$Other_Nuts+453*df$Soybeans
         +337*df$Mung_Beans+42*df$Soybean_Milk+82*df$Tofu+174*df$Dried_Tofu+494*df$Tofu_Skin+220*df$Tofu_Strips
         +238*df$Fried_Tofu+74*df$Soybean_Sprouts+19*df$Mung_Bean_Sprouts+0.96*55*df$Green_Beans 
         +0.88*19*df$Snow_Peas+0.96*51*df$String_Beans+0.95*16*df$White_Radish+39*df$Carrot_Leaves
         +0.96*27*df$Carrot+0*df$White_Radish_Leaves+0.88*45*df$Lotus_Root+0.63*64*df$Bamboo_Shoots
         +0.82*32*df$Cauliflower+55*df$Baby_Bok_Choy+0.94*26*df$Bokchoy+0.89*33*df$Chinese_Cabbage
         +0.9*39*df$Onion+0.85*117*df$Garlic+0.12*24*df$Water_Bamboo+0.74*59*df$Amaranth+0.86*18*df$Cabbage
         +0.9*45*df$Chinese_Chives+37*df$Water_Spinach+0.89*47*df$Spinach+0.94*47*df$Mustard_Greens+0.83*36*df$Turnip
         +0.98*52*df$Chinese_Broccoli+0.88*81*df$Shepherds_Purse+0.67*38*df$Celery+0.96*34*df$Rapeseed
         +0.94*12*df$Lettuce+0.8*11*df$Winter_Melon+0.92*24*df$Cucumber+0.83*33*df$Luffa
         +0.81*35*df$Bitter_Melon+0.85*24*df$Pumpkin+18*df$Chayote+22*df$Tomato+0.8*95*df$Chili_Pepper
         +0.95*21*df$Eggplant+0.91*20*df$Green_Pepper+12*df$Wood_Ear_Mushroom+97*df$Enoki_Mushroom
         +0.99*94*df$Mushroom+53*df$Shiitake_Mushroom+0.89*29*df$Scallion+22*df$Kelp
         +0.85*7*df$Apple+0.7*17*df$Banana+0.74*22*df$Orange+0.69*24*df$Pomelo+0.82*14*df$Pear
         +0.89*11*df$Peach+0.6*11*df$Mango+0.68*9*df$Pineapple+0.78*17*df$Muskmelon+0.86*13*df$Grape
         +0.92*39*df$Persimmon+0.5*30*df$Longan+0.73*24*df$Lychee+0.62*8*df$Loquat+0.59*12*df$Watermelon
         +0.97*27*df$Strawberry+0.83*26*df$Kiwi+0.69*35*df$Dragon_Fruit+0.78*44*df$Water_Chestnut
         +0.95*258*df$Dried_Shiitake+0.98*52*df$Dried_Kelp+350*df$Dried_Seaweed+504*df$Dried_Scallop+308*df$Dried_Fish
         +(43*0.45*df$White_Steamed_Bread+0.35*0.91*121*df$Pork+0.89*29*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*121*df$Pork+43*0.35*df$White_Steamed_Bread+0.89*29*0.05*df$Scallion+0.08*53*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*121*df$Pork+43*0.35*df$White_Steamed_Bread+0.15*0.9*45*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*121*df$Pork+43*0.35*df$White_Steamed_Bread+0.15*0.89*33*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*121*df$Pork+43*0.35*df$White_Steamed_Bread+0.1*0.9*45*df$Chinese_Chives+0.1*0.59*275*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$K = (30*df$rice+13*df$White_Congee+19*df$Rice_Noodles+17*df$Vermicelli+161*df$Noodles
         +209*df$Macaroni_Pasta+146*df$White_Steamed_Bread +356*df$Oatmeal+106*df$Oil_Cake
         +227*df$Deep_fried_dough_sticks+122*df$Baked_Cake+360*df$Fish_balls+275*df$Cuttlefish_Balls
         +0.86*174*df$Sweet_Potato+317*df$Taro+0.94*347*df$Potato+0.91*111*df$Jicama+0.84*226*df$Salted_Duck_Egg
         +0.9*152*df$Century_Egg+264*df$Pork_Floss+183*df$Ham_Sausage+0.87*154*df$Chicken_Egg+0.87*135*df$Duck_Egg
         +0.91*218*df$Pork+0.69*248*df$Pork_Chops+212*df$Beef+300*df$Mutton+0.63*249*df$Chicken
         +0.68*191*df$Duck+0.96*171*df$Pork_Tripe+235*df$Pork_Liver+0.6*54*df$Pork_Trotters
         +56*df$Pork_Blood+272*df$Chicken_Gizzard+0.69*205*df$Chicken_Wings+0.6*108*df$Chicken_Feet
         +0.58*312*df$Grass_Carp+0.61*277*df$Silver_Carp+0.54*290*df$Crucian_Carp+0.58*105*df$Perch
         +0.64*229*df$Yellow_Croaker+0.54*207*df$Eel+0.67*136*df$Sardine+0.63*325*df$Black_Carp 
         +0.49*308*df$Mackerel+0.72*378*df$Spanish_Mackerel+0.7*328*df$Pomfret+0.76*280*df$Hairtail
         +0.61*295*df$Mandarin_Fish+0.64*228*df$Dike_Fish+0.59*215*df$Bream+0.7*215*df$Horse_Mackerel
         +0.67*263*df$Rice_Eel+0.97*290*df$Squid+157*df$Octopus+214*df$Crab+0.59*363*df$Sea_Shrimp
         +0.41*167*df$Snail+0.39*140*df$Clam+200*df$Oyster+0.57*140*df$Razor_Clam+0.49*157*df$Mussel
         +245.5*df$Jellyfish+127*df$Fresh_Milk_Boxed_Milk+777*df$Milk_Powder+150*df$Yogurt+92*df$Soy_Milk
         +75*df$Breakfast_Milk_Breakfast_Drink+0.53*390*df$Peanuts+0.745*517.92*df$Other_Nuts+1199*df$Soybeans
         +787*df$Mung_Beans+117*df$Soybean_Milk+118*df$Tofu+137*df$Dried_Tofu+877*df$Tofu_Skin+74*df$Tofu_Strips
         +158*df$Fried_Tofu+160*df$Soybean_Sprouts+32*df$Mung_Bean_Sprouts+0.96*207*df$Green_Beans 
         +0.88*116*df$Snow_Peas+0.96*123*df$String_Beans+0.95*167*df$White_Radish+493*df$Carrot_Leaves
         +0.96*190*df$Carrot+0*df$White_Radish_Leaves+0.88*293*df$Lotus_Root+0.63*389*df$Bamboo_Shoots
         +0.82*206*df$Cauliflower+126*df$Baby_Bok_Choy+0.94*116*df$Bokchoy+0.89*134*df$Chinese_Cabbage
         +0.9*147*df$Onion+0.85*302*df$Garlic+0.12*0*df$Water_Bamboo+0.74*207*df$Amaranth+0.86*46*df$Cabbage
         +0.9*241*df$Chinese_Chives+304*df$Water_Spinach+0.89*311*df$Spinach+0.94*281*df$Mustard_Greens+0.83*243*df$Turnip
         +0.98*345*df$Chinese_Broccoli+0.88*280*df$Shepherds_Purse+0.67*206*df$Celery+0.96*143*df$Rapeseed
         +0.94*91*df$Lettuce+0.8*57*df$Winter_Melon+0.92*102*df$Cucumber+0.83*121*df$Luffa
         +0.81*256*df$Bitter_Melon+0.85*145*df$Pumpkin+76*df$Chayote+197*df$Tomato+0.8*222*df$Chili_Pepper
         +0.95*147*df$Eggplant+0.91*154*df$Green_Pepper+52*df$Wood_Ear_Mushroom+195*df$Enoki_Mushroom
         +0.99*312*df$Mushroom+20*df$Shiitake_Mushroom+0.89*123*df$Scallion+246*df$Kelp
         +0.85*83*df$Apple+0.7*208*df$Banana+0.74*159*df$Orange+0.69*119*df$Pomelo+0.82*85*df$Pear
         +0.89*127*df$Peach+0.6*138*df$Mango+0.68*113*df$Pineapple+0.78*139*df$Muskmelon+0.86*127*df$Grape
         +0.92*245*df$Persimmon+0.5*248*df$Longan+0.73*151*df$Lychee+0.62*122*df$Loquat+0.59*97*df$Watermelon
         +0.97*131*df$Strawberry+0.83*144*df$Kiwi+0.69*20*df$Dragon_Fruit+0.78*306*df$Water_Chestnut
         +0.95*464*df$Dried_Shiitake+0.98*761*df$Dried_Kelp+1796*df$Dried_Seaweed+969*df$Dried_Scallop+251*df$Dried_Fish
         +(146*0.45*df$White_Steamed_Bread+0.35*0.91*218*df$Pork+0.89*123*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*218*df$Pork+146*0.35*df$White_Steamed_Bread+0.89*123*0.05*df$Scallion+0.08*20*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*218*df$Pork+146*0.35*df$White_Steamed_Bread+0.15*0.9*241*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*218*df$Pork+146*0.35*df$White_Steamed_Bread+0.15*0.89*134*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*218*df$Pork+146*0.35*df$White_Steamed_Bread+0.1*0.9*241*df$Chinese_Chives+0.1*0.59*363*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Na = (2.5*df$rice+2.8*df$White_Congee+52.2*df$Rice_Noodles+9.3*df$Vermicelli+3.4*df$Noodles
         +35*df$Macaroni_Pasta+165*df$White_Steamed_Bread +2.1*df$Oatmeal+572.5*df$Oil_Cake
         +585.2*df$Deep_fried_dough_sticks+62.5*df$Baked_Cake+854.2*df$Fish_balls+825.2*df$Cuttlefish_Balls
         +0.86*58.2*df$Sweet_Potato+1*df$Taro+0.94*5.9*df$Potato+0.91*5.5*df$Jicama+0.84*1131*df$Salted_Duck_Egg
         +0.9*542.7*df$Century_Egg+1419.9*df$Pork_Floss+682.2*df$Ham_Sausage+0.87*131.5*df$Chicken_Egg+0.87*106*df$Duck_Egg
         +0.91*56.8*df$Pork+0.69*53.55*df$Pork_Chops+64.1*df$Beef+89.9*df$Mutton+0.63*62.8*df$Chicken
         +0.68*69*df$Duck+0.96*75.1*df$Pork_Tripe+68.6*df$Pork_Liver+0.6*101*df$Pork_Trotters
         +56*df$Pork_Blood+74.8*df$Chicken_Gizzard+0.69*50.8*df$Chicken_Wings+0.6*169*df$Chicken_Feet
         +0.58*46*df$Grass_Carp+0.61*57.5*df$Silver_Carp+0.54*41.2*df$Crucian_Carp+0.58*144.1*df$Perch
         +0.64*157.3*df$Yellow_Croaker+0.54*58.8*df$Eel+0.67*91.5*df$Sardine+0.63*47.4*df$Black_Carp 
         +0.49*56*df$Mackerel+0.72*36.7*df$Spanish_Mackerel+0.7*62.5*df$Pomfret+0.76*150.1*df$Hairtail
         +0.61*68.6*df$Mandarin_Fish+0.64*65*df$Dike_Fish+0.59*41.1*df$Bream+0.7*81.6*df$Horse_Mackerel
         +0.67*70.2*df$Rice_Eel+0.97*110*df$Squid+288.1*df$Octopus+270*df$Crab+0.59*168.8*df$Sea_Shrimp
         +0.41*153.3*df$Snail+0.39*425.7*df$Clam+462.1*df$Oyster+0.57*175.9*df$Razor_Clam+0.49*451.4*df$Mussel
         +396.35*df$Jellyfish+120.3*df$Fresh_Milk_Boxed_Milk+352*df$Milk_Powder+37.7*df$Yogurt+3.2*df$Soy_Milk
         +72.3*df$Breakfast_Milk_Breakfast_Drink+0.53*3.7*df$Peanuts+0.745*173.65*df$Other_Nuts+2.3*df$Soybeans
         +3.2*df$Mung_Beans+3.7*df$Soybean_Milk+5.6*df$Tofu+329*df$Dried_Tofu+7.4*df$Tofu_Skin+20.6*df$Tofu_Strips
         +32.5*df$Fried_Tofu+7.2*df$Soybean_Sprouts+25.8*df$Mung_Bean_Sprouts+0.96*3.4*df$Green_Beans 
         +0.88*8.8*df$Snow_Peas+0.96*8.6*df$String_Beans+0.95*54.3*df$White_Radish+74.6*df$Carrot_Leaves
         +0.96*74.1*df$Carrot+0*df$White_Radish_Leaves+0.88*34.3*df$Lotus_Root+0.63*0.4*df$Bamboo_Shoots
         +0.82*39.2*df$Cauliflower+170.2*df$Baby_Bok_Choy+0.94*132.2*df$Bokchoy+0.89*68.9*df$Chinese_Cabbage
         +0.9*14.4*df$Onion+0.85*19.6*df$Garlic+0.12*0*df$Water_Bamboo+0.74*32.4*df$Amaranth+0.86*42.1*df$Cabbage
         +0.9*5.8*df$Chinese_Chives+107.6*df$Water_Spinach+0.89*85.2*df$Spinach+0.94*30.5*df$Mustard_Greens+0.83*65.6*df$Turnip
         +0.98*40.2*df$Chinese_Broccoli+0.88*31.6*df$Shepherds_Purse+0.67*159*df$Celery+0.96*98.8*df$Rapeseed
         +0.94*16.1*df$Lettuce+0.8*2.8*df$Winter_Melon+0.92*4.9*df$Cucumber+0.83*3.7*df$Luffa
         +0.81*2.5*df$Bitter_Melon+0.85*0.8*df$Pumpkin+1*df$Chayote+246.9*df$Tomato+0.8*2.6*df$Chili_Pepper
         +0.95*5*df$Eggplant+0.91*7*df$Green_Pepper+8.5*df$Wood_Ear_Mushroom+4.3*df$Enoki_Mushroom
         +0.99*8.3*df$Mushroom+1.6*df$Shiitake_Mushroom+0.89*13.6*df$Scallion+8.6*df$Kelp
         +0.85*1.3*df$Apple+0.7*3.2*df$Banana+0.74*1.2*df$Orange+0.69*3*df$Pomelo+0.82*1.7*df$Pear
         +0.89*1.7*df$Peach+0.6*2.8*df$Mango+0.68*0.8*df$Pineapple+0.78*8.8*df$Muskmelon+0.86*1.9*df$Grape
         +0.92*3.6*df$Persimmon+0.5*3.9*df$Longan+0.73*1.7*df$Lychee+0.62*4*df$Loquat+0.59*3.3*df$Watermelon
         +0.97*4.2*df$Strawberry+0.83*10*df$Kiwi+0.69*2.7*df$Dragon_Fruit+0.78*15.7*df$Water_Chestnut
         +0.95*11.2*df$Dried_Shiitake+0.98*327.4*df$Dried_Kelp+710.5*df$Dried_Seaweed+306.4*df$Dried_Scallop+2320.6*df$Dried_Fish
         +(165*0.45*df$White_Steamed_Bread+0.35*0.91*56.8*df$Pork+0.89*13.6*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*56.8*df$Pork+165*0.35*df$White_Steamed_Bread+0.89*13.6*0.05*df$Scallion+0.08*1.6*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*56.8*df$Pork+165*0.35*df$White_Steamed_Bread+0.15*0.9*5.8*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*56.8*df$Pork+165*0.35*df$White_Steamed_Bread+0.15*0.89*68.9*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*56.8*df$Pork+165*0.35*df$White_Steamed_Bread+0.1*0.9*5.8*df$Chinese_Chives+0.1*0.59*168.8*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Mg = (15*df$rice+7*df$White_Congee+6*df$Rice_Noodles+11*df$Vermicelli+61*df$Noodles
         +58*df$Macaroni_Pasta+20*df$White_Steamed_Bread +115*df$Oatmeal+13*df$Oil_Cake
         +19*df$Deep_fried_dough_sticks+26*df$Baked_Cake+11*df$Fish_balls+6*df$Cuttlefish_Balls
         +0.86*17*df$Sweet_Potato+0*df$Taro+0.94*24*df$Potato+0.91*14*df$Jicama+0.84*22*df$Salted_Duck_Egg
         +0.9*13*df$Century_Egg+3*df$Pork_Floss+14*df$Ham_Sausage+0.87*10*df$Chicken_Egg+0.87*13*df$Duck_Egg
         +0.91*16*df$Pork+0.69*17*df$Pork_Chops+22*df$Beef+23*df$Mutton+0.63*22*df$Chicken
         +0.68*14*df$Duck+0.96*12*df$Pork_Tripe+24*df$Pork_Liver+0.6*5*df$Pork_Trotters
         +5*df$Pork_Blood+15*df$Chicken_Gizzard+0.69*17*df$Chicken_Wings+0.6*7*df$Chicken_Feet
         +0.58*31*df$Grass_Carp+0.61*23*df$Silver_Carp+0.54*41*df$Crucian_Carp+0.58*37*df$Perch
         +0.64*31*df$Yellow_Croaker+0.54*34*df$Eel+0.67*30*df$Sardine+0.63*32*df$Black_Carp 
         +0.49*24*df$Mackerel+0.72*27*df$Spanish_Mackerel+0.7*39*df$Pomfret+0.76*43*df$Hairtail
         +0.61*32*df$Mandarin_Fish+0.64*46*df$Dike_Fish+0.59*17*df$Bream+0.7*30*df$Horse_Mackerel
         +0.67*18*df$Rice_Eel+0.97*42*df$Squid+42*df$Octopus+41*df$Crab+0.59*63*df$Sea_Shrimp
         +0.41*143*df$Snail+0.39*78*df$Clam+65*df$Oyster+0.57*35*df$Razor_Clam+0.49*56*df$Mussel
         +119*df$Jellyfish+12*df$Fresh_Milk_Boxed_Milk+65*df$Milk_Powder+11*df$Yogurt+7*df$Soy_Milk
         +8*df$Breakfast_Milk_Breakfast_Drink+0.53*11*df$Peanuts+0.745*231.2*df$Other_Nuts+190*df$Soybeans
         +126*df$Mung_Beans+15*df$Soybean_Milk+41*df$Tofu+69*df$Dried_Tofu+179*df$Tofu_Skin+127*df$Tofu_Strips
         +72*df$Fried_Tofu+21*df$Soybean_Sprouts+18*df$Mung_Bean_Sprouts+0.96*35*df$Green_Beans 
         +0.88*16*df$Snow_Peas+0.96*27*df$String_Beans+0.95*12*df$White_Radish+33*df$Carrot_Leaves
         +0.96*14*df$Carrot+0*df$White_Radish_Leaves+0.88*14*df$Lotus_Root+0.63*1*df$Bamboo_Shoots
         +0.82*18*df$Cauliflower+41*df$Baby_Bok_Choy+0.94*30*df$Bokchoy+0.89*12*df$Chinese_Cabbage
         +0.9*15*df$Onion+0.85*21*df$Garlic+0.12*0*df$Water_Bamboo+0.74*119*df$Amaranth+0.86*14*df$Cabbage
         +0.9*24*df$Chinese_Chives+46*df$Water_Spinach+0.89*58*df$Spinach+0.94*24*df$Mustard_Greens+0.83*19*df$Turnip
         +0.98*40*df$Chinese_Broccoli+0.88*37*df$Shepherds_Purse+0.67*18*df$Celery+0.96*34*df$Rapeseed
         +0.94*7*df$Lettuce+0.8*10*df$Winter_Melon+0.92*15*df$Cucumber+0.83*19*df$Luffa
         +0.81*18*df$Bitter_Melon+0.85*8*df$Pumpkin+10*df$Chayote+12*df$Tomato+0.8*16*df$Chili_Pepper
         +0.95*11*df$Eggplant+0.91*15*df$Green_Pepper+57*df$Wood_Ear_Mushroom+17*df$Enoki_Mushroom
         +0.99*11*df$Mushroom+11*df$Shiitake_Mushroom+0.89*19*df$Scallion+25*df$Kelp
         +0.85*4*df$Apple+0.7*33*df$Banana+0.74*14*df$Orange+0.69*4*df$Pomelo+0.82*8*df$Pear
         +0.89*8*df$Peach+0.6*14*df$Mango+0.68*8*df$Pineapple+0.78*11*df$Muskmelon+0.86*7*df$Grape
         +0.92*20*df$Persimmon+0.5*10*df$Longan+0.73*12*df$Lychee+0.62*10*df$Loquat+0.59*14*df$Watermelon
         +0.97*12*df$Strawberry+0.83*12*df$Kiwi+0.69*30*df$Dragon_Fruit+0.78*12*df$Water_Chestnut
         +0.95*147*df$Dried_Shiitake+0.98*129*df$Dried_Kelp+105*df$Dried_Seaweed+106*df$Dried_Scallop+60*df$Dried_Fish
         +(20*0.45*df$White_Steamed_Bread+0.35*0.91*16*df$Pork+0.89*19*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*16*df$Pork+20*0.35*df$White_Steamed_Bread+0.89*19*0.05*df$Scallion+0.08*11*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*16*df$Pork+20*0.35*df$White_Steamed_Bread+0.15*0.9*24*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*16*df$Pork+20*0.35*df$White_Steamed_Bread+0.15*0.89*12*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*16*df$Pork+20*0.35*df$White_Steamed_Bread+0.1*0.9*24*df$Chinese_Chives+0.1*0.59*63*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Fe = (1.3*df$rice+0.1*df$White_Congee+2.4*df$Rice_Noodles+6.4*df$Vermicelli+2.6*df$Noodles
         +2.6*df$Macaroni_Pasta+0.4*df$White_Steamed_Bread +2.9*df$Oatmeal+2.3*df$Oil_Cake
         +1*df$Deep_fried_dough_sticks+1.6*df$Baked_Cake+1.2*df$Fish_balls+0.9*df$Cuttlefish_Balls
         +0.86*0.8*df$Sweet_Potato+0.5*df$Taro+0.94*0.4*df$Potato+0.91*0.6*df$Jicama+0.84*2.1*df$Salted_Duck_Egg
         +0.9*3.3*df$Century_Egg+7.7*df$Pork_Floss+2.2*df$Ham_Sausage+0.87*1.6*df$Chicken_Egg+0.87*2.9*df$Duck_Egg
         +0.91*1.3*df$Pork+0.69*0.85*df$Pork_Chops+1.8*df$Beef+3.9*df$Mutton+0.63*1.8*df$Chicken
         +0.68*2.2*df$Duck+0.96*2.4*df$Pork_Tripe+23.2*df$Pork_Liver+0.6*1.1*df$Pork_Trotters
         +8.7*df$Pork_Blood+4.4*df$Chicken_Gizzard+0.69*0.9*df$Chicken_Wings+0.6*1.4*df$Chicken_Feet
         +0.58*0.8*df$Grass_Carp+0.61*1.4*df$Silver_Carp+0.54*1.3*df$Crucian_Carp+0.58*2*df$Perch
         +0.64*0.7*df$Yellow_Croaker+0.54*1.5*df$Eel+0.67*1.4*df$Sardine+0.63*0.9*df$Black_Carp 
         +0.49*1.4*df$Mackerel+0.72*2.5*df$Spanish_Mackerel+0.7*1.1*df$Pomfret+0.76*1.2*df$Hairtail
         +0.61*1*df$Mandarin_Fish+0.64*2.2*df$Dike_Fish+0.59*0.7*df$Bream+0.7*1.8*df$Horse_Mackerel
         +0.67*2.5*df$Rice_Eel+0.97*0.9*df$Squid+1.4*df$Octopus+1.8*df$Crab+0.59*2*df$Sea_Shrimp
         +0.41*7*df$Snail+0.39*10.9*df$Clam+7.1*df$Oyster+0.57*33.6*df$Razor_Clam+0.49*6.7*df$Mussel
         +4.95*df$Jellyfish+0.3*df$Fresh_Milk_Boxed_Milk+4.6*df$Milk_Powder+0.3*df$Yogurt+0.6*df$Soy_Milk
         +0.7*df$Breakfast_Milk_Breakfast_Drink+0.53*3.4*df$Peanuts+0.745*4.43*df$Other_Nuts+7.9*df$Soybeans
         +6.5*df$Mung_Beans+0.4*df$Soybean_Milk+1.2*df$Tofu+7.1*df$Dried_Tofu+11.7*df$Tofu_Skin+9.1*df$Tofu_Strips
         +5.2*df$Fried_Tofu+0.9*df$Soybean_Sprouts+0.3*df$Mung_Bean_Sprouts+0.96*1.5*df$Green_Beans 
         +0.88*0.9*df$Snow_Peas+0.96*1.3*df$String_Beans+0.95*0.2*df$White_Radish+8.1*df$Carrot_Leaves
         +0.96*1*df$Carrot+0*df$White_Radish_Leaves+0.88*0.3*df$Lotus_Root+0.63*0.5*df$Bamboo_Shoots
         +0.82*0.4*df$Cauliflower+1*df$Baby_Bok_Choy+0.94*1.3*df$Bokchoy+0.89*0.8*df$Chinese_Cabbage
         +0.9*0.6*df$Onion+0.85*1.2*df$Garlic+0.12*0.2*df$Water_Bamboo+0.74*5.4*df$Amaranth+0.86*0.2*df$Cabbage
         +0.9*0.7*df$Chinese_Chives+1*df$Water_Spinach+0.89*2.9*df$Spinach+0.94*3.2*df$Mustard_Greens+0.83*0.8*df$Turnip
         +0.98*1*df$Chinese_Broccoli+0.88*5.4*df$Shepherds_Purse+0.67*1.2*df$Celery+0.96*5.9*df$Rapeseed
         +0.94*0.2*df$Lettuce+0.8*0.1*df$Winter_Melon+0.92*0.5*df$Cucumber+0.83*0.3*df$Luffa
         +0.81*0.7*df$Bitter_Melon+0.85*0.4*df$Pumpkin+0.1*df$Chayote+0.4*df$Tomato+0.8*1.4*df$Chili_Pepper
         +0.95*0.5*df$Eggplant+0.91*0.3*df$Green_Pepper+5.5*df$Wood_Ear_Mushroom+1.4*df$Enoki_Mushroom
         +0.99*1.2*df$Mushroom+0.3*df$Shiitake_Mushroom+0.89*1.3*df$Scallion+0.9*df$Kelp
         +0.85*0.3*df$Apple+0.7*0.2*df$Banana+0.74*0.4*df$Orange+0.69*0.3*df$Pomelo+0.82*0.4*df$Pear
         +0.89*0.3*df$Peach+0.6*0.2*df$Mango+0.68*0.6*df$Pineapple+0.78*0.7*df$Muskmelon+0.86*0.4*df$Grape
         +0.92*1.45*df$Persimmon+0.5*0.2*df$Longan+0.73*0.4*df$Lychee+0.62*1.1*df$Loquat+0.59*0.4*df$Watermelon
         +0.97*1.8*df$Strawberry+0.83*1.2*df$Kiwi+0.69*0.3*df$Dragon_Fruit+0.78*0.6*df$Water_Chestnut
         +0.95*10.5*df$Dried_Shiitake+0.98*4.7*df$Dried_Kelp+54.9*df$Dried_Seaweed+5.6*df$Dried_Scallop+4.4*df$Dried_Fish
         +(0.4*0.45*df$White_Steamed_Bread+0.35*0.91*1.3*df$Pork+0.89*1.3*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*1.3*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.89*1.3*0.05*df$Scallion+0.08*0.3*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*1.3*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.15*0.9*0.7*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*1.3*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.15*0.89*0.8*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*1.3*df$Pork+0.4*0.35*df$White_Steamed_Bread+0.1*0.9*0.7*df$Chinese_Chives+0.1*0.59*2*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Zn = (0.92*df$rice+0.2*df$White_Congee+0.36*df$Rice_Noodles+0.27*df$Vermicelli+1.07*df$Noodles
         +1.55*df$Macaroni_Pasta+0.21*df$White_Steamed_Bread +1.75*df$Oatmeal+0.97*df$Oil_Cake
         +0.75*df$Deep_fried_dough_sticks+0.36*df$Baked_Cake+1.59*df$Fish_balls+0.98*df$Cuttlefish_Balls
         +0.86*0.22*df$Sweet_Potato+0*df$Taro+0.94*0.3*df$Potato+0.91*0.23*df$Jicama+0.84*1.5*df$Salted_Duck_Egg
         +0.9*1.48*df$Century_Egg+2.89*df$Pork_Floss+2.11*df$Ham_Sausage+0.87*0.89*df$Chicken_Egg+0.87*1.67*df$Duck_Egg
         +0.91*1.78*df$Pork+0.69*2.07*df$Pork_Chops+4.7*df$Beef+3.52*df$Mutton+0.63*1.46*df$Chicken
         +0.68*1.33*df$Duck+0.96*1.92*df$Pork_Tripe+3.68*df$Pork_Liver+0.6*1.14*df$Pork_Trotters
         +0.28*df$Pork_Blood+2.76*df$Chicken_Gizzard+0.69*0.42*df$Chicken_Wings+0.6*0.9*df$Chicken_Feet
         +0.58*0.87*df$Grass_Carp+0.61*1.17*df$Silver_Carp+0.54*1.94*df$Crucian_Carp+0.58*2.83*df$Perch
         +0.64*0.73*df$Yellow_Croaker+0.54*1.15*df$Eel+0.67*0.16*df$Sardine+0.63*0.96*df$Black_Carp 
         +0.49*1*df$Mackerel+0.72*0.4*df$Spanish_Mackerel+0.7*0.8*df$Pomfret+0.76*0.7*df$Hairtail
         +0.61*1.07*df$Mandarin_Fish+0.64*1.2*df$Dike_Fish+0.59*0.89*df$Bream+0.7*0.85*df$Horse_Mackerel
         +0.67*1.97*df$Rice_Eel+0.97*2.38*df$Squid+5.18*df$Octopus+2.15*df$Crab+0.59*1.78*df$Sea_Shrimp
         +0.41*4.6*df$Snail+0.39*2.38*df$Clam+9.39*df$Oyster+0.57*2.01*df$Razor_Clam+0.49*2.47*df$Mussel
         +0.485*df$Jellyfish+0.24*df$Fresh_Milk_Boxed_Milk+3.93*df$Milk_Powder+0.43*df$Yogurt+0.24*df$Soy_Milk
         +0.34*df$Breakfast_Milk_Breakfast_Drink+0.53*1.79*df$Peanuts+0.745*4.024*df$Other_Nuts+3.57*df$Soybeans
         +2.18*df$Mung_Beans+0.28*df$Soybean_Milk+0.57*df$Tofu+1.84*df$Dried_Tofu+4.08*df$Tofu_Skin+2.04*df$Tofu_Strips
         +2.03*df$Fried_Tofu+0.54*df$Soybean_Sprouts+0.2*df$Mung_Bean_Sprouts+0.96*0.54*df$Green_Beans 
         +0.88*0.5*df$Snow_Peas+0.96*0.23*df$String_Beans+0.95*0.14*df$White_Radish+0.67*df$Carrot_Leaves
         +0.96*0.23*df$Carrot+0*df$White_Radish_Leaves+0.88*0.24*df$Lotus_Root+0.63*0.33*df$Bamboo_Shoots
         +0.82*0.17*df$Cauliflower+0.28*df$Baby_Bok_Choy+0.94*0.23*df$Bokchoy+0.89*0.46*df$Chinese_Cabbage
         +0.9*0.23*df$Onion+0.85*0.88*df$Garlic+0.12*0*df$Water_Bamboo+0.74*0.8*df$Amaranth+0.86*0.12*df$Cabbage
         +0.9*0.25*df$Chinese_Chives+0.27*df$Water_Spinach+0.89*0.85*df$Spinach+0.94*0.7*df$Mustard_Greens+0.83*0.39*df$Turnip
         +0.98*0.4*df$Chinese_Broccoli+0.88*0.68*df$Shepherds_Purse+0.67*0.24*df$Celery+0.96*1.27*df$Rapeseed
         +0.94*0.12*df$Lettuce+0.8*0.1*df$Winter_Melon+0.92*0.18*df$Cucumber+0.83*0.22*df$Luffa
         +0.81*0.36*df$Bitter_Melon+0.85*0.14*df$Pumpkin+0.08*df$Chayote+0.24*df$Tomato+0.8*0.3*df$Chili_Pepper
         +0.95*0.2*df$Eggplant+0.91*0.21*df$Green_Pepper+0.53*df$Wood_Ear_Mushroom+0.39*df$Enoki_Mushroom
         +0.99*0.92*df$Mushroom+0.66*df$Shiitake_Mushroom+0.89*0.22*df$Scallion+0.16*df$Kelp
         +0.85*0.04*df$Apple+0.7*0.04*df$Banana+0.74*0.14*df$Orange+0.69*0.4*df$Pomelo+0.82*0.1*df$Pear
         +0.89*0.14*df$Peach+0.6*0.09*df$Mango+0.68*0.14*df$Pineapple+0.78*0.09*df$Muskmelon+0.86*0.16*df$Grape
         +0.92*0.155*df$Persimmon+0.5*0.4*df$Longan+0.73*0.17*df$Lychee+0.62*0.21*df$Loquat+0.59*0.09*df$Watermelon
         +0.97*0.14*df$Strawberry+0.83*0.57*df$Kiwi+0.69*0.29*df$Dragon_Fruit+0.78*0.34*df$Water_Chestnut
         +0.95*8.57*df$Dried_Shiitake+0.98*0.65*df$Dried_Kelp+2.47*df$Dried_Seaweed+5.05*df$Dried_Scallop+2.94*df$Dried_Fish
         +(0.21*0.45*df$White_Steamed_Bread+0.35*0.91*1.78*df$Pork+0.89*0.22*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*1.78*df$Pork+0.21*0.35*df$White_Steamed_Bread+0.89*0.22*0.05*df$Scallion+0.08*0.66*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*1.78*df$Pork+0.21*0.35*df$White_Steamed_Bread+0.15*0.9*0.25*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*1.78*df$Pork+0.21*0.35*df$White_Steamed_Bread+0.15*0.89*0.46*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*1.78*df$Pork+0.21*0.35*df$White_Steamed_Bread+0.1*0.9*0.25*df$Chinese_Chives+0.1*0.59*1.78*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Se = (0.4*df$rice+0.2*df$White_Congee+0.45*df$Rice_Noodles+3.39*df$Vermicelli+0.4*df$Noodles
         +5.8*df$Macaroni_Pasta+2.66*df$White_Steamed_Bread +0*df$Oatmeal+10.6*df$Oil_Cake
         +86*df$Deep_fried_dough_sticks+12.16*df$Baked_Cake+14.02*df$Fish_balls+13.39*df$Cuttlefish_Balls
         +0.86*0.63*df$Sweet_Potato+0.0*df$Taro+0.94*0.47*df$Potato+0.91*0.16*df$Jicama+0.84*32.76*df$Salted_Duck_Egg
         +0.9*25.24*df$Century_Egg+13.37*df$Pork_Floss+4.94*df$Ham_Sausage+0.87*13.96*df$Chicken_Egg+0.87*15.68*df$Duck_Egg
         +0.91*7.9*df$Pork+0.69*9.38*df$Pork_Chops+3.15*df$Beef+5.95*df$Mutton+0.63*11.92*df$Chicken
         +0.68*12.25*df$Duck+0.96*12.76*df$Pork_Tripe+26.12*df$Pork_Liver+0.6*5.85*df$Pork_Trotters
         +7.94*df$Pork_Blood+10.54*df$Chicken_Gizzard+0.69*8.72*df$Chicken_Wings+0.6*9.95*df$Chicken_Feet
         +0.58*6.66*df$Grass_Carp+0.61*15.68*df$Silver_Carp+0.54*14.31*df$Crucian_Carp+0.58*33.06*df$Perch
         +0.64*34.64*df$Yellow_Croaker+0.54*33.66*df$Eel+0.67*48.95*df$Sardine+0.63*37.69*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*27.21*df$Pomfret+0.76*36.57*df$Hairtail
         +0.61*26.5*df$Mandarin_Fish+0.64*80.36*df$Dike_Fish+0.59*11.59*df$Bream+0.7*24.89*df$Horse_Mackerel
         +0.67*34.56*df$Rice_Eel+0.97*38.18*df$Squid+41.86*df$Octopus+33.3*df$Crab+0.59*28.39*df$Sea_Shrimp
         +0.41*37.94*df$Snail+0.39*54.31*df$Clam+86.64*df$Oyster+0.57*55.14*df$Razor_Clam+0.49*57.77*df$Mussel
         +16.07*df$Jellyfish+0*df$Fresh_Milk_Boxed_Milk+12.09*df$Milk_Powder+1.3*df$Yogurt+0.73*df$Soy_Milk
         +0*df$Breakfast_Milk_Breakfast_Drink+0.53*4.5*df$Peanuts+0.745*6.736*df$Other_Nuts+6.19*df$Soybeans
         +4.28*df$Mung_Beans+0*df$Soybean_Milk+1.5*df$Tofu+7.12*df$Dried_Tofu+2.26*df$Tofu_Skin+1.39*df$Tofu_Strips
         +0.63*df$Fried_Tofu+0.96*df$Soybean_Sprouts+0.27*df$Mung_Bean_Sprouts+0.96*2.16*df$Green_Beans 
         +0.88*0.42*df$Snow_Peas+0.96*0.43*df$String_Beans+0.95*0.12*df$White_Radish+0.89*df$Carrot_Leaves
         +0.96*0.63*df$Carrot+0*df$White_Radish_Leaves+0.88*0.17*df$Lotus_Root+0.63*0.04*df$Bamboo_Shoots
         +0.82*2.86*df$Cauliflower+0.43*df$Baby_Bok_Choy+0.94*0.39*df$Bokchoy+0.89*0.57*df$Chinese_Cabbage
         +0.9*0.92*df$Onion+0.85*3.09*df$Garlic+0.12*0*df$Water_Bamboo+0.74*0.52*df$Amaranth+0.86*0.27*df$Cabbage
         +0.9*1.33*df$Chinese_Chives+0*df$Water_Spinach+0.89*0.97*df$Spinach+0.94*0.7*df$Mustard_Greens+0.83*0.95*df$Turnip
         +0.98*0.39*df$Chinese_Broccoli+0.88*0.51*df$Shepherds_Purse+0.67*0.57*df$Celery+0.96*0*df$Rapeseed
         +0.94*0.04*df$Lettuce+0.8*0.02*df$Winter_Melon+0.92*0.38*df$Cucumber+0.83*0.2*df$Luffa
         +0.81*0.36*df$Bitter_Melon+0.85*0.46*df$Pumpkin+1.45*df$Chayote+0.5*df$Tomato+0.8*1.9*df$Chili_Pepper
         +0.95*0.09*df$Eggplant+0.91*0.02*df$Green_Pepper+0.46*df$Wood_Ear_Mushroom+0.28*df$Enoki_Mushroom
         +0.99*0.55*df$Mushroom+2.58*df$Shiitake_Mushroom+0.89*0.74*df$Scallion+9.54*df$Kelp
         +0.85*0.1*df$Apple+0.7*0.07*df$Banana+0.74*0.31*df$Orange+0.69*0.7*df$Pomelo+0.82*0.29*df$Pear
         +0.89*0.47*df$Peach+0.6*1.44*df$Mango+0.68*0.24*df$Pineapple+0.78*0.4*df$Muskmelon+0.86*1.11*df$Grape
         +0.92*0.535*df$Persimmon+0.5*0.83*df$Longan+0.73*0.14*df$Lychee+0.62*0.72*df$Loquat+0.59*0.09*df$Watermelon
         +0.97*0.7*df$Strawberry+0.83*0.28*df$Kiwi+0.69*0.03*df$Dragon_Fruit+0.78*0.7*df$Water_Chestnut
         +0.95*6.42*df$Dried_Shiitake+0.98*5.84*df$Dried_Kelp+7.22*df$Dried_Seaweed+76.35*df$Dried_Scallop+0.37*df$Dried_Fish
         +(2.66*0.45*df$White_Steamed_Bread+0.35*0.91*7.9*df$Pork+0.89*0.74*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*7.9*df$Pork+2.66*0.35*df$White_Steamed_Bread+0.89*0.74*0.05*df$Scallion+0.08*2.58*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*7.9*df$Pork+2.66*0.35*df$White_Steamed_Bread+0.15*0.9*1.33*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*7.9*df$Pork+2.66*0.35*df$White_Steamed_Bread+0.15*0.89*0.57*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*7.9*df$Pork+2.66*0.35*df$White_Steamed_Bread+0.1*0.9*1.33*df$Chinese_Chives+0.1*0.59*28.39*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Cu = (0.06*df$rice+0.03*df$White_Congee+0*df$Rice_Noodles+0.05*df$Vermicelli+0.2*df$Noodles
         +0.16*df$Macaroni_Pasta+0.02*df$White_Steamed_Bread +0.21*df$Oatmeal+0.27*df$Oil_Cake
         +0.19*df$Deep_fried_dough_sticks+0.15*df$Baked_Cake+0.11*df$Fish_balls+0.14*df$Cuttlefish_Balls
         +0.86*0.16*df$Sweet_Potato+0.0*df$Taro+0.94*0.09*df$Potato+0.91*0.07*df$Jicama+0.84*0.2*df$Salted_Duck_Egg
         +0.9*0.12*df$Century_Egg+0.64*df$Pork_Floss+0.12*df$Ham_Sausage+0.87*0.19*df$Chicken_Egg+0.87*0.11*df$Duck_Egg
         +0.91*0.12*df$Pork+0.69*0.12*df$Pork_Chops+0.05*df$Beef+0.13*df$Mutton+0.63*0.09*df$Chicken
         +0.68*0.21*df$Duck+0.96*0.1*df$Pork_Tripe+0.02*df$Pork_Liver+0.6*0.09*df$Pork_Trotters
         +0.1*df$Pork_Blood+2.11*df$Chicken_Gizzard+0.69*0*df$Chicken_Wings+0.6*0.05*df$Chicken_Feet
         +0.58*0.05*df$Grass_Carp+0.61*0.06*df$Silver_Carp+0.54*0.08*df$Crucian_Carp+0.58*0.05*df$Perch
         +0.64*0.04*df$Yellow_Croaker+0.54*0.18*df$Eel+0.67*0.02*df$Sardine+0.63*0.06*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*0*df$Spanish_Mackerel+0.7*0.14*df$Pomfret+0.76*0.08*df$Hairtail
         +0.61*0.1*df$Mandarin_Fish+0.64*0.07*df$Dike_Fish+0.59*0.07*df$Bream+0.7*0.11*df$Horse_Mackerel
         +0.67*0.05*df$Rice_Eel+0.97*0.45*df$Squid+9*df$Octopus+1.33*df$Crab+0.59*1.48*df$Sea_Shrimp
         +0.41*1.05*df$Snail+0.39*0.11*df$Clam+8.13*df$Oyster+0.57*0.38*df$Razor_Clam+0.49*0.13*df$Mussel
         +0.165*df$Jellyfish+0.01*df$Fresh_Milk_Boxed_Milk+0.13*df$Milk_Powder+0.04*df$Yogurt+5.57*df$Soy_Milk
         +0*df$Breakfast_Milk_Breakfast_Drink+0.53*0.68*df$Peanuts+0.745*1.241*df$Other_Nuts+1.43*df$Soybeans
         +1.08*df$Mung_Beans+0.16*df$Soybean_Milk+0.08*df$Tofu+0.41*df$Dried_Tofu+1.17*df$Tofu_Skin+0.29*df$Tofu_Strips
         +0.3*df$Fried_Tofu+0.14*df$Soybean_Sprouts+0.05*df$Mung_Bean_Sprouts+0.96*0.15*df$Green_Beans 
         +0.88*0.06*df$Snow_Peas+0.96*0.11*df$String_Beans+0.95*0.01*df$White_Radish+0.12*df$Carrot_Leaves
         +0.96*0.08*df$Carrot+0*df$White_Radish_Leaves+0.88*0.09*df$Lotus_Root+0.63*0.02*df$Bamboo_Shoots
         +0.82*0.05*df$Cauliflower+0.02*df$Baby_Bok_Choy+0.94*0.06*df$Bokchoy+0.89*0.05*df$Chinese_Cabbage
         +0.9*0.05*df$Onion+0.85*0.22*df$Garlic+0.12*0*df$Water_Bamboo+0.74*0.13*df$Amaranth+0.86*0.01*df$Cabbage
         +0.9*0.05*df$Chinese_Chives+0.05*df$Water_Spinach+0.89*0.1*df$Spinach+0.94*0.08*df$Mustard_Greens+0.83*0.09*df$Turnip
         +0.98*0.03*df$Chinese_Broccoli+0.88*0.29*df$Shepherds_Purse+0.67*0.09*df$Celery+0.96*0*df$Rapeseed
         +0.94*0.01*df$Lettuce+0.8*0.01*df$Winter_Melon+0.92*0.05*df$Cucumber+0.83*0.05*df$Luffa
         +0.81*0.06*df$Bitter_Melon+0.85*0.03*df$Pumpkin+0.02*df$Chayote+0.05*df$Tomato+0.8*0.11*df$Chili_Pepper
         +0.95*0.04*df$Eggplant+0.91*0.05*df$Green_Pepper+0.04*df$Wood_Ear_Mushroom+0.14*df$Enoki_Mushroom
         +0.99*0.49*df$Mushroom+0.12*df$Shiitake_Mushroom+0.89*0.01*df$Scallion+0*df$Kelp
         +0.85*0.07*df$Apple+0.7*0.1*df$Banana+0.74*0.03*df$Orange+0.69*0.18*df$Pomelo+0.82*0.1*df$Pear
         +0.89*0.06*df$Peach+0.6*0.06*df$Mango+0.68*0.07*df$Pineapple+0.78*0.04*df$Muskmelon+0.86*0.18*df$Grape
         +0.92*0.1*df$Persimmon+0.5*0.1*df$Longan+0.73*0.16*df$Lychee+0.62*0.06*df$Loquat+0.59*0.03*df$Watermelon
         +0.97*0.04*df$Strawberry+0.83*1.87*df$Kiwi+0.69*0.04*df$Dragon_Fruit+0.78*0.07*df$Water_Chestnut
         +0.95*1.03*df$Dried_Shiitake+0.98*0.14*df$Dried_Kelp+1.68*df$Dried_Seaweed+0.1*df$Dried_Scallop+0.16*df$Dried_Fish
         +(0.02*0.45*df$White_Steamed_Bread+0.35*0.91*0.12*df$Pork+0.89*0.01*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0.12*df$Pork+0.02*0.35*df$White_Steamed_Bread+0.89*0.01*0.05*df$Scallion+0.08*0.12*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0.12*df$Pork+0.02*0.35*df$White_Steamed_Bread+0.15*0.9*0.05*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0.12*df$Pork+0.02*0.35*df$White_Steamed_Bread+0.15*0.89*0.05*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0.12*df$Pork+0.02*0.35*df$White_Steamed_Bread+0.1*0.9*0.05*df$Chinese_Chives+0.1*0.59*1.48*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
df$Mn = (0.58*df$rice+0.2*df$White_Congee+0.08*df$Rice_Noodles+0.15*df$Vermicelli+1.35*df$Noodles
         +0.67*df$Macaroni_Pasta+0.03*df$White_Steamed_Bread +3.91*df$Oatmeal+0.71*df$Oil_Cake
         +0.52*df$Deep_fried_dough_sticks+0.08*df$Baked_Cake+0.09*df$Fish_balls+0.14*df$Cuttlefish_Balls
         +0.86*0.21*df$Sweet_Potato+0.0*df$Taro+0.94*0.1*df$Potato+0.91*0.11*df$Jicama+0.84*0.07*df$Salted_Duck_Egg
         +0.9*0.06*df$Century_Egg+0.33*df$Pork_Floss+0.1*df$Ham_Sausage+0.87*0.03*df$Chicken_Egg+0.87*0.04*df$Duck_Egg
         +0.91*0.03*df$Pork+0.69*0.05*df$Pork_Chops+0.03*df$Beef+0.06*df$Mutton+0.63*0.05*df$Chicken
         +0.68*0.06*df$Duck+0.96*0.12*df$Pork_Tripe+0.01*df$Pork_Liver+0.6*0.01*df$Pork_Trotters
         +0.03*df$Pork_Blood+0.06*df$Chicken_Gizzard+0.69*0.01*df$Chicken_Wings+0.6*0.03*df$Chicken_Feet
         +0.58*0.05*df$Grass_Carp+0.61*0.09*df$Silver_Carp+0.54*0.06*df$Crucian_Carp+0.58*0.04*df$Perch
         +0.64*0.04*df$Yellow_Croaker+0.54*0*df$Eel+0.67*0.07*df$Sardine+0.63*0.04*df$Black_Carp 
         +0.49*0*df$Mackerel+0.72*0.03*df$Spanish_Mackerel+0.7*0.07*df$Pomfret+0.76*0.17*df$Hairtail
         +0.61*0.03*df$Mandarin_Fish+0.64*0.03*df$Dike_Fish+0.59*0.05*df$Bream+0.7*0.05*df$Horse_Mackerel
         +0.67*2.22*df$Rice_Eel+0.97*0.08*df$Squid+90.4*df$Octopus+0.31*df$Crab+0.59*0.22*df$Sea_Shrimp
         +0.41*0.72*df$Snail+0.39*0.44*df$Clam+0.85*df$Oyster+0.57*1.93*df$Razor_Clam+0.49*0.41*df$Mussel
         +1.1*df$Jellyfish+0.01*df$Fresh_Milk_Boxed_Milk+0.04*df$Milk_Powder+0.01*df$Yogurt+0.11*df$Soy_Milk
         +0*df$Breakfast_Milk_Breakfast_Drink+0.53*0.65*df$Peanuts+0.745*3.6*df$Other_Nuts+2.45*df$Soybeans
         +1.11*df$Mung_Beans+0.16*df$Soybean_Milk+0.12*df$Tofu+1.07*df$Dried_Tofu+2.71*df$Tofu_Skin+1.71*df$Tofu_Strips
         +1.38*df$Fried_Tofu+0.34*df$Soybean_Sprouts+0.05*df$Mung_Bean_Sprouts+0.96*0.41*df$Green_Beans 
         +0.88*0.48*df$Snow_Peas+0.96*0.18*df$String_Beans+0.95*0.05*df$White_Radish+0.36*df$Carrot_Leaves
         +0.96*0.24*df$Carrot+0*df$White_Radish_Leaves+0.88*0.89*df$Lotus_Root+0.63*1.14*df$Bamboo_Shoots
         +0.82*0.09*df$Cauliflower+0.24*df$Baby_Bok_Choy+0.94*0.15*df$Bokchoy+0.89*0.19*df$Chinese_Cabbage
         +0.9*0.14*df$Onion+0.85*0.29*df$Garlic+0.12*0*df$Water_Bamboo+0.74*0.78*df$Amaranth+0.86*0.09*df$Cabbage
         +0.9*0.21*df$Chinese_Chives+0.52*df$Water_Spinach+0.89*0.66*df$Spinach+0.94*0.42*df$Mustard_Greens+0.83*0.15*df$Turnip
         +0.98*0.31*df$Chinese_Broccoli+0.88*0.65*df$Shepherds_Purse+0.67*0.16*df$Celery+0.96*1.09*df$Rapeseed
         +0.94*0.06*df$Lettuce+0.8*0.02*df$Winter_Melon+0.92*0.06*df$Cucumber+0.83*0.07*df$Luffa
         +0.81*0.16*df$Bitter_Melon+0.85*0.08*df$Pumpkin+0.03*df$Chayote+0.06*df$Tomato+0.8*0.18*df$Chili_Pepper
         +0.95*0.09*df$Eggplant+0.91*0.05*df$Green_Pepper+0.97*df$Wood_Ear_Mushroom+0.1*df$Enoki_Mushroom
         +0.99*0.11*df$Mushroom+0.25*df$Shiitake_Mushroom+0.89*0.11*df$Scallion+0.07*df$Kelp
         +0.85*0.03*df$Apple+0.7*0.07*df$Banana+0.74*0.05*df$Orange+0.69*0.08*df$Pomelo+0.82*0.06*df$Pear
         +0.89*0.07*df$Peach+0.6*0.2*df$Mango+0.68*1.04*df$Pineapple+0.78*0.04*df$Muskmelon+0.86*0.04*df$Grape
         +0.92*0.405*df$Persimmon+0.5*0.07*df$Longan+0.73*0.09*df$Lychee+0.62*0.34*df$Loquat+0.59*0.03*df$Watermelon
         +0.97*0.49*df$Strawberry+0.83*0.73*df$Kiwi+0.69*0.19*df$Dragon_Fruit+0.78*0.11*df$Water_Chestnut
         +0.95*5.47*df$Dried_Shiitake+0.98*1.14*df$Dried_Kelp+4.32*df$Dried_Seaweed+0.43*df$Dried_Scallop+0.17*df$Dried_Fish
         +(0.03*0.45*df$White_Steamed_Bread+0.35*0.91*0.03*df$Pork+0.89*0.11*0.05*df$Scallion)*df$Pork_Buns
         +(0.45*0.91*0.03*df$Pork+0.03*0.35*df$White_Steamed_Bread+0.89*0.11*0.05*df$Scallion+0.08*0.25*df$Shiitake_Mushroom)*df$Dumplings_Pork_Mushroom
         +(0.4*0.91*0.03*df$Pork+0.03*0.35*df$White_Steamed_Bread+0.15*0.9*0.21*df$Chinese_Chives)*df$Dumplings_Pork_Chive
         +(0.4*0.91*0.03*df$Pork+0.03*0.35*df$White_Steamed_Bread+0.15*0.89*0.19*df$Chinese_Cabbage)*df$Dumplings_Pork_Cabbage
         +(0.3*0.91*0.03*df$Pork+0.03*0.35*df$White_Steamed_Bread+0.1*0.9*0.21*df$Chinese_Chives+0.1*0.59*0.22*df$Sea_Shrimp)*df$Dumplings_Three_Fresh
)
  return(df)
}
