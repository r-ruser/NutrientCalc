#' Calculate Nutrients
#' @param file_path Path to the input Excel file
#' @return Processed data frame
#' @export
calculate_nutrients <- function(file_path) {
  xlsx_path <- file_path
df <- readxl::read_excel(xlsx_path, sheet = 1)

head(df)

# ---- robust preprocessing for FFQ-coded input ----
# Keep original data frame structure, but force all intake-related fields
# used in arithmetic to numeric. This avoids Excel-imported character columns
# such as "5_8；B4.02Times；" causing multiplication errors.
df[is.na(df)] <- 0

freq_cols   <- grep("Frequency", names(df), value = TRUE)
times_cols  <- grep("Times", names(df), value = TRUE)
amount_cols <- grep("Amount", names(df), value = TRUE)

num_safe <- function(x) {
  x_chr <- trimws(as.character(x))
  x_chr[x_chr %in% c("", "NA", "N/A", "NULL", "NaN", "<NA>")] <- "0"
  x_chr <- gsub("，", ".", x_chr, fixed = TRUE)
  x_chr <- gsub(",", ".", x_chr, fixed = TRUE)
  out <- suppressWarnings(as.numeric(x_chr))
  out[is.na(out)] <- 0
  out
}

freq_recode <- function(x) {
  x_chr <- trimws(as.character(x))
  x_chr[x_chr %in% c("", "NA", "N/A", "NULL", "NaN", "<NA>")] <- "0"
  out <- dplyr::recode(
    x_chr,
    `0` = 0,
    `1` = 0,
    `2` = 12/365,
    `3` = 7/365,
    `4` = 1,
    .default = suppressWarnings(as.numeric(x_chr)),
    .missing = 0
  )
  out[is.na(out)] <- 0
  as.numeric(out)
}

if (length(freq_cols) > 0) {
  df[freq_cols] <- lapply(df[freq_cols], freq_recode)
}
if (length(times_cols) > 0) {
  df[times_cols] <- lapply(df[times_cols], num_safe)
}
if (length(amount_cols) > 0) {
  df[amount_cols] <- lapply(df[amount_cols], num_safe)
}

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

  # Added nutrients from China Food Composition Tables (amino acids, fatty acids, purines)
  # Rules: Tr treated as 0; multiple matched source rows averaged; unmatched foods/components set to 0.
  calc_sparse_nutrient <- function(coef_map) {
    total <- rep(0, nrow(df))
    if (length(coef_map) > 0) {
      for (food in names(coef_map)) {
        if (food %in% names(df)) total <- total + unname(coef_map[[food]]) * df[[food]]
      }
    }
    getv <- function(x) if (x %in% names(coef_map)) unname(coef_map[[x]]) else 0
    total <- total + (0.45 * getv("White_Steamed_Bread") + 0.35 * getv("Pork") + 0.05 * getv("Scallion")) * df$Pork_Buns
    total <- total + (0.45 * getv("Pork") + 0.35 * getv("White_Steamed_Bread") + 0.05 * getv("Scallion") + 0.08 * getv("Shiitake_Mushroom")) * df$Dumplings_Pork_Mushroom
    total <- total + (0.4 * getv("Pork") + 0.35 * getv("White_Steamed_Bread") + 0.15 * getv("Chinese_Chives")) * df$Dumplings_Pork_Chive
    total <- total + (0.4 * getv("Pork") + 0.35 * getv("White_Steamed_Bread") + 0.15 * getv("Chinese_Cabbage")) * df$Dumplings_Pork_Cabbage
    total <- total + (0.3 * getv("Pork") + 0.35 * getv("White_Steamed_Bread") + 0.1 * getv("Chinese_Chives") + 0.1 * getv("Sea_Shrimp")) * df$Dumplings_Three_Fresh
    total
  }

  df$isoleucine <- calc_sparse_nutrient(
c(rice = 100, White_Congee = 50, Rice_Noodles = 289, Noodles = 177, Macaroni_Pasta = 426, Oatmeal = 440,
  Deep_fried_dough_sticks = 247, Fish_balls = 440, Cuttlefish_Balls = 500, Sweet_Potato = 42.14, Taro = 75,
  Salted_Duck_Egg = 588, Century_Egg = 556.2, Pork_Floss = 1052, Ham_Sausage = 641.25, Chicken_Egg = 564.63,
  Duck_Egg = 507.21, Pork = 575.12, Pork_Chops = 427.455, Beef = 850, Mutton = 835, Rabbit_Meat = 889,
  Chicken = 545.58, Duck = 457.64, Pork_Tripe = 487.68, Pork_Liver = 640, Pork_Trotters = 228,
  Chicken_Gizzard = 865, Chicken_Wings = 489.9, Grass_Carp = 435.58, Silver_Carp = 445.91,
  Crucian_Carp = 416.34, Perch = 522.58, Yellow_Croaker = 461.12, Sardine = 408.7, Black_Carp = 569.52,
  Mackerel = 307.23, Spanish_Mackerel = 691.2, Pomfret = 583.1, Hairtail = 566.96, Mandarin_Fish = 525.21,
  Dike_Fish = 451.2, Bream = 499.73, Rice_Eel = 515.23, Squid = 687.73, Crab = 912, Sea_Shrimp = 446.63,
  Clam = 158.34, Oyster = 222, Razor_Clam = 145.92, Mussel = 213.15, Jellyfish = 145,
  Fresh_Milk_Boxed_Milk = 130, Milk_Powder = 1046, Yogurt = 122, Soy_Milk = 61,
  Breakfast_Milk_Breakfast_Drink = 120, Peanuts = 162.71, Other_Nuts = 410.880134, Soybeans = 1853,
  Mung_Beans = 976, Tofu = 265, Dried_Tofu = 860, Tofu_Skin = 2140, Tofu_Strips = 822, Fried_Tofu = 793,
  Soybean_Sprouts = 191, Mung_Bean_Sprouts = 85, Snow_Peas = 58.08, White_Radish_Leaves = 144,
  Carrot_Leaves = 129, Carrot = 36.48, White_Radish = 19.95, Lotus_Root = 38.72, Bamboo_Shoots = 49.14,
  Bokchoy = 47.94, Chinese_Cabbage = 32.04, Onion = 28.8, Garlic = 90.1, Amaranth = 115.44,
  Chinese_Chives = 79.2, Water_Spinach = 45, Spinach = 89, Mustard_Greens = 81.78, Shepherds_Purse = 101.2,
  Rapeseed = 52.8, Winter_Melon = 9.6, Cucumber = 17.48, Luffa = 22.41, Bitter_Melon = 23.49,
  Pumpkin = 16.15, Tomato = 13, Chili_Pepper = 32, Eggplant = 35.625, Green_Pepper = 36.4,
  Wood_Ear_Mushroom = 63, Enoki_Mushroom = 69, Mushroom = 98.01, Shiitake_Mushroom = 212, Kelp = 64,
  Apple = 10.2, Banana = 29.4, Orange = 12.58, Pomelo = 13.11, Pear = 4.92, Peach = 24.03, Mango = 9.6,
  Pineapple = 10.2, Muskmelon = 7.8, Grape = 6.88, Persimmon = 12.88, Longan = 13, Lychee = 16.06,
  Loquat = 23.56, Watermelon = 10.62, Strawberry = 23.28, Kiwi = 21.58, Water_Chestnut = 17.94,
  Dried_Shiitake = 1574.15, Dried_Kelp = 62.72, Dried_Seaweed = 683, Dried_Scallop = 1327, Dried_Fish = 1761)
  )

  df$leucine <- calc_sparse_nutrient(
c(rice = 200, White_Congee = 110, Rice_Noodles = 568, Noodles = 415, Macaroni_Pasta = 894, Oatmeal = 872,
  Deep_fried_dough_sticks = 523, Fish_balls = 830, Cuttlefish_Balls = 930, Sweet_Potato = 68.8, Taro = 171,
  Salted_Duck_Egg = 882, Century_Egg = 998.1, Pork_Floss = 1970, Ham_Sausage = 1088, Chicken_Egg = 910.89,
  Duck_Egg = 923.94, Pork = 1111.11, Pork_Chops = 819.03, Beef = 1563, Mutton = 1541, Rabbit_Meat = 1571,
  Chicken = 1020.6, Duck = 844.56, Pork_Tripe = 961.92, Pork_Liver = 1560, Pork_Trotters = 517.2,
  Chicken_Gizzard = 1452, Chicken_Wings = 924.6, Chicken_Feet = 735.6, Grass_Carp = 759.8,
  Silver_Carp = 758.23, Crucian_Carp = 720.36, Perch = 914.66, Yellow_Croaker = 858.24, Sardine = 716.9,
  Black_Carp = 967.05, Mackerel = 537.04, Spanish_Mackerel = 1268.64, Pomfret = 954.8, Hairtail = 997.88,
  Mandarin_Fish = 963.19, Dike_Fish = 763.52, Bream = 959.34, Rice_Eel = 885.74, Squid = 1249.36,
  Crab = 1620, Sea_Shrimp = 856.09, Clam = 241.02, Oyster = 357, Razor_Clam = 254.79, Mussel = 330.26,
  Jellyfish = 213.5, Fresh_Milk_Boxed_Milk = 247, Milk_Powder = 1543, Yogurt = 225, Soy_Milk = 109,
  Breakfast_Milk_Breakfast_Drink = 221, Peanuts = 367.29, Other_Nuts = 744.567188, Soybeans = 2819,
  Mung_Beans = 1761, Tofu = 511, Dried_Tofu = 1339, Tofu_Skin = 4020, Tofu_Strips = 1331, Fried_Tofu = 1359,
  Soybean_Sprouts = 248, Mung_Bean_Sprouts = 111, Snow_Peas = 128.48, White_Radish_Leaves = 250,
  Carrot_Leaves = 202, Carrot = 48, White_Radish = 25.65, Lotus_Root = 57.2, Bamboo_Shoots = 79.38,
  Bokchoy = 91.18, Chinese_Cabbage = 48.95, Onion = 44.1, Garlic = 157.25, Amaranth = 194.62,
  Chinese_Chives = 142.2, Water_Spinach = 141, Spinach = 161.98, Mustard_Greens = 147.58,
  Shepherds_Purse = 176.88, Rapeseed = 89.28, Winter_Melon = 13.6, Cucumber = 30.36, Luffa = 38.18,
  Bitter_Melon = 40.5, Pumpkin = 17.85, Tomato = 20, Chili_Pepper = 48.8, Eggplant = 42.275,
  Green_Pepper = 55.51, Enoki_Mushroom = 92, Mushroom = 112.86, Shiitake_Mushroom = 117, Kelp = 79,
  Apple = 12.75, Banana = 60.2, Orange = 19.24, Pomelo = 20.01, Pear = 5.74, Peach = 52.51, Mango = 15.6,
  Pineapple = 15.64, Muskmelon = 13.26, Grape = 9.46, Persimmon = 19.32, Longan = 22.5, Lychee = 24.82,
  Loquat = 28.52, Watermelon = 10.62, Strawberry = 43.65, Kiwi = 24.9, Water_Chestnut = 45.24,
  Dried_Shiitake = 1086.8, Dried_Kelp = 77.42, Dried_Seaweed = 1848, Dried_Scallop = 4179, Dried_Fish = 3872)
  )

  df$lysine <- calc_sparse_nutrient(
c(rice = 100, White_Congee = 50, Rice_Noodles = 264, Noodles = 142, Macaroni_Pasta = 264, Oatmeal = 501,
  Deep_fried_dough_sticks = 114, Fish_balls = 930, Cuttlefish_Balls = 1010, Sweet_Potato = 68.8, Taro = 85,
  Salted_Duck_Egg = 697.2, Century_Egg = 733.5, Pork_Floss = 1952, Ham_Sausage = 1087.5,
  Chicken_Egg = 736.02, Duck_Egg = 751.68, Pork = 1203.02, Pork_Chops = 892.86, Beef = 1722, Mutton = 1713,
  Rabbit_Meat = 1603, Chicken = 1108.8, Duck = 876.52, Pork_Tripe = 830.4, Pork_Liver = 1290,
  Pork_Trotters = 564, Chicken_Gizzard = 1351, Chicken_Wings = 966, Chicken_Feet = 716.4,
  Grass_Carp = 854.92, Silver_Carp = 929.03, Crucian_Carp = 798.12, Perch = 876.96, Yellow_Croaker = 962.24,
  Sardine = 737, Black_Carp = 1147.86, Mackerel = 606.13, Spanish_Mackerel = 1238.76, Pomfret = 1054.9,
  Hairtail = 1076.92, Mandarin_Fish = 1125.45, Dike_Fish = 1007.36, Bream = 1094.45, Rice_Eel = 985.57,
  Squid = 1176.61, Crab = 1760, Sea_Shrimp = 859.63, Clam = 376.74, Oyster = 366, Razor_Clam = 241.11,
  Mussel = 419.93, Jellyfish = 198, Fresh_Milk_Boxed_Milk = 214, Milk_Powder = 1523, Yogurt = 185,
  Soy_Milk = 106, Breakfast_Milk_Breakfast_Drink = 186, Peanuts = 240.09, Other_Nuts = 373.614509,
  Soybeans = 2237, Mung_Beans = 1626, Tofu = 394, Dried_Tofu = 999, Tofu_Skin = 3220, Tofu_Strips = 981,
  Fried_Tofu = 956, Soybean_Sprouts = 189, Mung_Bean_Sprouts = 85, Snow_Peas = 33.44,
  White_Radish_Leaves = 189, Carrot_Leaves = 148, Carrot = 45.12, White_Radish = 29.45, Lotus_Root = 52.8,
  Bamboo_Shoots = 71.19, Bokchoy = 74.26, Chinese_Cabbage = 45.39, Onion = 40.5, Garlic = 164.9,
  Amaranth = 142.82, Chinese_Chives = 108, Water_Spinach = 95, Spinach = 130.83, Mustard_Greens = 111.86,
  Shepherds_Purse = 102.08, Rapeseed = 85.44, Winter_Melon = 8.8, Cucumber = 30.36, Luffa = 39.01,
  Bitter_Melon = 56.7, Pumpkin = 21.25, Tomato = 23, Chili_Pepper = 50.4, Eggplant = 54.15,
  Green_Pepper = 57.33, Enoki_Mushroom = 71, Mushroom = 94.05, Shiitake_Mushroom = 68, Kelp = 64,
  Apple = 12.75, Banana = 42, Orange = 20.72, Pomelo = 20.7, Pear = 4.92, Peach = 10.68, Mango = 21.6,
  Pineapple = 1.36, Muskmelon = 11.7, Grape = 11.18, Persimmon = 18.4, Longan = 18.5, Lychee = 24.09,
  Loquat = 27.28, Watermelon = 10.62, Strawberry = 30.07, Kiwi = 13.28, Water_Chestnut = 42.12,
  Dried_Shiitake = 837.9, Dried_Kelp = 62.72, Dried_Seaweed = 1086, Dried_Scallop = 4502, Dried_Fish = 3684)
  )

  df$SAA <- calc_sparse_nutrient(
c(rice = 120, White_Congee = 70, Rice_Noodles = 178, Noodles = 300, Macaroni_Pasta = 373, Oatmeal = 386,
  Deep_fried_dough_sticks = 269, Fish_balls = 460, Cuttlefish_Balls = 530, Sweet_Potato = 38.7, Taro = 58,
  Salted_Duck_Egg = 596.4, Century_Egg = 648, Pork_Floss = 806, Ham_Sausage = 460, Chicken_Egg = 718.62,
  Duck_Egg = 662.07, Pork = 503.23, Pork_Chops = 397.785, Beef = 514, Mutton = 611, Rabbit_Meat = 847,
  Chicken = 288.54, Duck = 359.72, Pork_Tripe = 395.52, Pork_Liver = 680, Pork_Trotters = 231.6,
  Chicken_Gizzard = 212, Chicken_Wings = 476.1, Chicken_Feet = 228.6, Grass_Carp = 360.18,
  Silver_Carp = 440.42, Crucian_Carp = 409.32, Yellow_Croaker = 427.52, Sardine = 368.5, Black_Carp = 535.5,
  Mackerel = 348.39, Spanish_Mackerel = 370.44, Pomfret = 499.8, Hairtail = 446.88, Mandarin_Fish = 373.32,
  Dike_Fish = 197.76, Bream = 369.93, Rice_Eel = 491.11, Squid = 146.47, Crab = 853, Sea_Shrimp = 417.72,
  Clam = 113.1, Oyster = 204, Razor_Clam = 101.46, Mussel = 270.48, Jellyfish = 138.5,
  Fresh_Milk_Boxed_Milk = 80, Milk_Powder = 495, Yogurt = 39, Soy_Milk = 98,
  Breakfast_Milk_Breakfast_Drink = 70, Peanuts = 50.35, Other_Nuts = 298.231473, Soybeans = 902,
  Mung_Beans = 489, Tofu = 180, Dried_Tofu = 296, Tofu_Skin = 1430, Tofu_Strips = 350, Fried_Tofu = 381,
  Soybean_Sprouts = 109, Mung_Bean_Sprouts = 57, White_Radish_Leaves = 90, Carrot_Leaves = 56,
  Carrot = 39.36, White_Radish = 21.85, Lotus_Root = 62.48, Bamboo_Shoots = 34.65, Bokchoy = 21.62,
  Chinese_Cabbage = 28.48, Onion = 26.1, Garlic = 46.75, Amaranth = 29.6, Chinese_Chives = 43.2,
  Water_Spinach = 17, Spinach = 32.04, Mustard_Greens = 50.76, Shepherds_Purse = 56.32, Rapeseed = 17.28,
  Winter_Melon = 5.6, Cucumber = 22.08, Luffa = 7.47, Bitter_Melon = 7.29, Pumpkin = 10.2, Tomato = 17,
  Chili_Pepper = 61.6, Eggplant = 22.8, Green_Pepper = 70.07, Wood_Ear_Mushroom = 29, Enoki_Mushroom = 54,
  Mushroom = 74.25, Kelp = 49, Apple = 14.45, Banana = 25.9, Orange = 10.36, Pomelo = 31.05, Pear = 9.84,
  Peach = 8.9, Muskmelon = 5.46, Grape = 12.9, Persimmon = 5.52, Longan = 6, Lychee = 3.65, Loquat = 4.96,
  Watermelon = 6.49, Strawberry = 16.49, Kiwi = 9.96, Water_Chestnut = 21.84, Dried_Shiitake = 532,
  Dried_Kelp = 48.02, Dried_Seaweed = 785, Dried_Scallop = 1280, Dried_Fish = 1518)
  )

  df$methionine <- calc_sparse_nutrient(
c(rice = 70, White_Congee = 40, Rice_Noodles = 178, Noodles = 100, Macaroni_Pasta = 173, Oatmeal = 162,
  Deep_fried_dough_sticks = 99, Fish_balls = 350, Cuttlefish_Balls = 380, Sweet_Potato = 17.2, Taro = 19,
  Potato = 22.56, Salted_Duck_Egg = 445.2, Century_Egg = 438.3, Pork_Floss = 423, Ham_Sausage = 282.666667,
  Chicken_Egg = 284.49, Duck_Egg = 435, Pork = 315.77, Pork_Chops = 250.815, Beef = 248, Mutton = 389,
  Rabbit_Meat = 526, Chicken = 269.64, Duck = 216.92, Pork_Tripe = 219.84, Pork_Liver = 390,
  Pork_Trotters = 64.2, Chicken_Wings = 351.9, Chicken_Feet = 115.8, Grass_Carp = 239.54,
  Silver_Carp = 300.73, Crucian_Carp = 278.64, Yellow_Croaker = 301.44, Sardine = 294.8, Black_Carp = 343.98,
  Mackerel = 204.82, Spanish_Mackerel = 275.4, Pomfret = 352.8, Hairtail = 297.16, Mandarin_Fish = 373.32,
  Dike_Fish = 197.76, Bream = 260.78, Rice_Eel = 318.92, Crab = 178, Sea_Shrimp = 304.44, Clam = 83.46,
  Oyster = 148, Razor_Clam = 101.46, Mussel = 123.48, Jellyfish = 63.5, Fresh_Milk_Boxed_Milk = 63,
  Milk_Powder = 189, Yogurt = 11, Soy_Milk = 39, Breakfast_Milk_Breakfast_Drink = 49, Other_Nuts = 170.925,
  Soybeans = 385, Mung_Beans = 269, Tofu = 87, Dried_Tofu = 162, Tofu_Skin = 750, Tofu_Strips = 120,
  Fried_Tofu = 163, Soybean_Sprouts = 36, Mung_Bean_Sprouts = 33, White_Radish_Leaves = 38,
  Carrot_Leaves = 23, Carrot = 18.24, White_Radish = 10.45, Lotus_Root = 34.32, Bamboo_Shoots = 16.38,
  Bokchoy = 8.46, Chinese_Cabbage = 10.68, Onion = 26.1, Garlic = 46.75, Chinese_Chives = 18.9,
  Water_Spinach = 17, Spinach = 16.02, Mustard_Greens = 26.32, Shepherds_Purse = 35.2, Rapeseed = 17.28,
  Winter_Melon = 2.4, Cucumber = 10.12, Luffa = 7.47, Bitter_Melon = 7.29, Pumpkin = 4.25, Tomato = 6,
  Chili_Pepper = 32, Eggplant = 6.65, Green_Pepper = 36.4, Enoki_Mushroom = 32, Mushroom = 53.46, Kelp = 49,
  Apple = 4.25, Banana = 25.9, Orange = 4.44, Pomelo = 31.05, Pear = 5.74, Peach = 0.89, Muskmelon = 1.56,
  Grape = 6.02, Persimmon = 1.84, Longan = 6, Lychee = 3.65, Loquat = 2.48, Watermelon = 2.36,
  Strawberry = 7.76, Kiwi = 4.98, Water_Chestnut = 11.7, Dried_Shiitake = 234.65, Dried_Kelp = 48.02,
  Dried_Seaweed = 659, Dried_Scallop = 1280, Dried_Fish = 1087)
  )

  df$cystine <- calc_sparse_nutrient(
c(rice = 50, White_Congee = 30, Noodles = 200, Macaroni_Pasta = 200, Oatmeal = 224,
  Deep_fried_dough_sticks = 170, Fish_balls = 110, Cuttlefish_Balls = 150, Sweet_Potato = 21.5, Taro = 39,
  Salted_Duck_Egg = 151.2, Century_Egg = 209.7, Pork_Floss = 383, Ham_Sausage = 177.333333,
  Chicken_Egg = 434.13, Duck_Egg = 227.07, Pork = 188.37, Pork_Chops = 146.97, Beef = 265, Mutton = 257,
  Rabbit_Meat = 321, Chicken = 183.33, Duck = 142.8, Pork_Tripe = 175.68, Pork_Liver = 290,
  Pork_Trotters = 167.4, Chicken_Gizzard = 212, Chicken_Wings = 124.2, Chicken_Feet = 112.8,
  Grass_Carp = 120.64, Silver_Carp = 139.69, Crucian_Carp = 130.68, Yellow_Croaker = 126.08, Sardine = 73.7,
  Black_Carp = 191.52, Mackerel = 143.57, Spanish_Mackerel = 190.08, Pomfret = 147, Hairtail = 149.72,
  Bream = 109.15, Rice_Eel = 172.19, Squid = 146.47, Crab = 675, Sea_Shrimp = 113.28, Clam = 29.64,
  Oyster = 56, Mussel = 147, Jellyfish = 75, Fresh_Milk_Boxed_Milk = 17, Milk_Powder = 306, Yogurt = 36,
  Soy_Milk = 59, Breakfast_Milk_Breakfast_Drink = 21, Peanuts = 50.35, Other_Nuts = 151.72433,
  Soybeans = 517, Mung_Beans = 220, Tofu = 93, Dried_Tofu = 134, Tofu_Skin = 680, Tofu_Strips = 230,
  Fried_Tofu = 218, Soybean_Sprouts = 73, Mung_Bean_Sprouts = 24, White_Radish_Leaves = 52,
  Carrot_Leaves = 33, Carrot = 21.12, White_Radish = 11.4, Lotus_Root = 28.16, Bamboo_Shoots = 18.27,
  Bokchoy = 13.16, Chinese_Cabbage = 17.8, Amaranth = 29.6, Chinese_Chives = 24.3, Spinach = 16.02,
  Mustard_Greens = 24.44, Shepherds_Purse = 21.12, Winter_Melon = 3.2, Cucumber = 11.96, Pumpkin = 5.95,
  Tomato = 11, Chili_Pepper = 29.6, Eggplant = 16.15, Green_Pepper = 33.67, Wood_Ear_Mushroom = 29,
  Enoki_Mushroom = 22, Mushroom = 20.79, Apple = 10.2, Orange = 5.92, Pear = 4.1, Peach = 8.01,
  Muskmelon = 3.9, Grape = 6.88, Persimmon = 3.68, Loquat = 2.48, Watermelon = 4.13, Strawberry = 8.73,
  Kiwi = 4.98, Water_Chestnut = 10.14, Dried_Shiitake = 297.35, Dried_Seaweed = 126, Dried_Fish = 431)
  )

  df$AAA <- calc_sparse_nutrient(
c(rice = 260, White_Congee = 140, Rice_Noodles = 617, Noodles = 437, Macaroni_Pasta = 923, Oatmeal = 897,
  Deep_fried_dough_sticks = 617, Fish_balls = 810, Cuttlefish_Balls = 910, Sweet_Potato = 97.18, Taro = 205,
  Salted_Duck_Egg = 1125.6, Century_Egg = 1264.5, Pork_Floss = 2938, Ham_Sausage = 1154,
  Chicken_Egg = 997.02, Duck_Egg = 1114.47, Pork = 1098.37, Pork_Chops = 788.67, Beef = 1460, Mutton = 1380,
  Rabbit_Meat = 1681, Chicken = 853.02, Duck = 840.48, Pork_Tripe = 880.32, Pork_Liver = 1540,
  Pork_Trotters = 486.6, Chicken_Gizzard = 1288, Chicken_Wings = 883.2, Chicken_Feet = 555.6,
  Grass_Carp = 687.3, Silver_Carp = 757.01, Crucian_Carp = 677.7, Perch = 819.54, Yellow_Croaker = 820.48,
  Sardine = 737, Black_Carp = 915.39, Mackerel = 523.32, Spanish_Mackerel = 1194.84, Pomfret = 848.4,
  Hairtail = 959.12, Mandarin_Fish = 1030.9, Dike_Fish = 673.92, Bream = 853.14, Rice_Eel = 942.69,
  Squid = 1128.11, Crab = 1878, Sea_Shrimp = 805.94, Clam = 255.45, Oyster = 410, Razor_Clam = 301.53,
  Mussel = 388.57, Jellyfish = 149.5, Fresh_Milk_Boxed_Milk = 230, Milk_Powder = 1933, Yogurt = 229,
  Soy_Milk = 169, Breakfast_Milk_Breakfast_Drink = 185, Peanuts = 429.3, Other_Nuts = 885.218304,
  Soybeans = 3013, Mung_Beans = 2102, Tofu = 576, Dried_Tofu = 1447, Tofu_Skin = 4380, Tofu_Strips = 1424,
  Fried_Tofu = 1510, Soybean_Sprouts = 286, Mung_Bean_Sprouts = 155, Snow_Peas = 123.2,
  White_Radish_Leaves = 318, Carrot_Leaves = 276, Carrot = 46.08, White_Radish = 30.4, Lotus_Root = 58.96,
  Bamboo_Shoots = 244.44, Bokchoy = 90.24, Chinese_Cabbage = 62.3, Onion = 57.6, Garlic = 196.35,
  Amaranth = 241.98, Chinese_Chives = 135, Water_Spinach = 117, Spinach = 170.88, Mustard_Greens = 121.26,
  Shepherds_Purse = 188.32, Rapeseed = 95.04, Winter_Melon = 18.4, Cucumber = 31.28, Luffa = 42.33,
  Bitter_Melon = 81, Pumpkin = 33.15, Tomato = 34, Chili_Pepper = 76.8, Eggplant = 64.125,
  Green_Pepper = 87.36, Wood_Ear_Mushroom = 90, Enoki_Mushroom = 129, Mushroom = 100.98,
  Shiitake_Mushroom = 140, Kelp = 77, Apple = 27.2, Banana = 50.4, Orange = 22.94, Pomelo = 40.02,
  Pear = 11.48, Peach = 38.27, Mango = 20.4, Muskmelon = 15.6, Grape = 20.64, Persimmon = 18.4, Longan = 25,
  Lychee = 24.09, Loquat = 23.56, Watermelon = 14.16, Strawberry = 37.83, Kiwi = 31.54,
  Water_Chestnut = 48.36, Dried_Shiitake = 975.65, Dried_Kelp = 75.46, Dried_Seaweed = 1774,
  Dried_Scallop = 3291, Dried_Fish = 3335)
  )

  df$phenylalanine <- calc_sparse_nutrient(
c(rice = 170, White_Congee = 90, Rice_Noodles = 361, Noodles = 274, Macaroni_Pasta = 553, Oatmeal = 615,
  Deep_fried_dough_sticks = 358, Fish_balls = 460, Cuttlefish_Balls = 480, Sweet_Potato = 61.06, Taro = 108,
  Salted_Duck_Egg = 638.4, Century_Egg = 712.8, Pork_Floss = 1821, Ham_Sausage = 619.25,
  Chicken_Egg = 567.24, Duck_Egg = 618.57, Pork = 556.01, Pork_Chops = 403.305, Beef = 789, Mutton = 755,
  Rabbit_Meat = 885, Chicken = 444.78, Duck = 423.64, Pork_Tripe = 498.24, Pork_Liver = 840,
  Pork_Trotters = 325.2, Chicken_Gizzard = 724, Chicken_Wings = 476.1, Chicken_Feet = 343.8,
  Grass_Carp = 386.86, Silver_Carp = 424.56, Crucian_Carp = 380.16, Perch = 444.86, Yellow_Croaker = 432.32,
  Sardine = 388.6, Black_Carp = 507.78, Mackerel = 272.93, Spanish_Mackerel = 646.56, Pomfret = 450.8,
  Hairtail = 520.6, Mandarin_Fish = 547.17, Dike_Fish = 359.04, Bream = 473.18, Rice_Eel = 538.01,
  Squid = 607.22, Crab = 978, Sea_Shrimp = 407.1, Clam = 127.14, Oyster = 203, Razor_Clam = 163.59,
  Mussel = 188.16, Jellyfish = 91.5, Fresh_Milk_Boxed_Milk = 118, Milk_Powder = 987, Yogurt = 111,
  Soy_Milk = 92, Breakfast_Milk_Breakfast_Drink = 102, Peanuts = 263.41, Other_Nuts = 532.153125,
  Soybeans = 1844, Mung_Beans = 1412, Tofu = 335, Dried_Tofu = 862, Tofu_Skin = 2440, Tofu_Strips = 824,
  Fried_Tofu = 861, Soybean_Sprouts = 191, Mung_Bean_Sprouts = 110, Snow_Peas = 72.16,
  White_Radish_Leaves = 192, Carrot_Leaves = 169, Carrot = 27.84, White_Radish = 17.1, Lotus_Root = 29.04,
  Bamboo_Shoots = 49.77, Bokchoy = 51.7, Chinese_Cabbage = 39.16, Onion = 41.4, Garlic = 106.25,
  Amaranth = 134.68, Chinese_Chives = 84.6, Water_Spinach = 61, Spinach = 96.12, Mustard_Greens = 89.3,
  Shepherds_Purse = 98.56, Rapeseed = 55.68, Winter_Melon = 11.2, Cucumber = 17.48, Luffa = 21.58,
  Bitter_Melon = 48.6, Pumpkin = 14.45, Tomato = 20, Chili_Pepper = 40, Eggplant = 39.9, Green_Pepper = 45.5,
  Wood_Ear_Mushroom = 54, Enoki_Mushroom = 58, Mushroom = 65.34, Shiitake_Mushroom = 77, Kelp = 44,
  Apple = 14.45, Banana = 32.2, Orange = 12.58, Pomelo = 11.73, Pear = 5.74, Peach = 23.14, Mango = 12,
  Muskmelon = 8.58, Grape = 12.04, Persimmon = 12.88, Longan = 11, Lychee = 13.14, Loquat = 12.4,
  Watermelon = 8.26, Strawberry = 21.34, Kiwi = 14.94, Water_Chestnut = 20.28, Dried_Shiitake = 577.6,
  Dried_Kelp = 43.12, Dried_Seaweed = 1061, Dried_Scallop = 1788, Dried_Fish = 1885)
  )

  df$tyrosine <- calc_sparse_nutrient(
c(rice = 90, White_Congee = 50, Rice_Noodles = 256, Noodles = 163, Macaroni_Pasta = 370, Oatmeal = 282,
  Deep_fried_dough_sticks = 259, Fish_balls = 350, Cuttlefish_Balls = 430, Sweet_Potato = 36.12, Taro = 97,
  Salted_Duck_Egg = 487.2, Century_Egg = 551.7, Pork_Floss = 1117, Ham_Sausage = 534.75,
  Chicken_Egg = 430.65, Duck_Egg = 495.9, Pork = 541.45, Pork_Chops = 385.365, Beef = 671, Mutton = 693,
  Rabbit_Meat = 796, Chicken = 408.24, Duck = 416.84, Pork_Tripe = 382.08, Pork_Liver = 700,
  Pork_Trotters = 161.4, Chicken_Gizzard = 564, Chicken_Wings = 407.1, Chicken_Feet = 211.8,
  Grass_Carp = 300.44, Silver_Carp = 332.45, Crucian_Carp = 297.54, Perch = 374.68, Yellow_Croaker = 388.16,
  Sardine = 348.4, Black_Carp = 407.61, Mackerel = 250.39, Spanish_Mackerel = 548.28, Pomfret = 397.6,
  Hairtail = 438.52, Mandarin_Fish = 483.73, Dike_Fish = 314.88, Bream = 379.96, Rice_Eel = 404.68,
  Squid = 520.89, Crab = 900, Sea_Shrimp = 398.84, Clam = 128.31, Oyster = 207, Razor_Clam = 137.94,
  Mussel = 200.41, Jellyfish = 58, Fresh_Milk_Boxed_Milk = 105, Milk_Powder = 946, Yogurt = 118,
  Soy_Milk = 77, Breakfast_Milk_Breakfast_Drink = 83, Peanuts = 165.89, Other_Nuts = 353.065179,
  Soybeans = 1169, Mung_Beans = 690, Tofu = 241, Dried_Tofu = 585, Tofu_Skin = 1940, Tofu_Strips = 600,
  Fried_Tofu = 649, Soybean_Sprouts = 95, Mung_Bean_Sprouts = 45, Snow_Peas = 51.04,
  White_Radish_Leaves = 126, Carrot_Leaves = 107, Carrot = 18.24, White_Radish = 13.3, Lotus_Root = 29.92,
  Bamboo_Shoots = 194.67, Bokchoy = 38.54, Chinese_Cabbage = 23.14, Onion = 16.2, Garlic = 90.1,
  Amaranth = 107.3, Chinese_Chives = 50.4, Water_Spinach = 56, Spinach = 74.76, Mustard_Greens = 31.96,
  Shepherds_Purse = 89.76, Rapeseed = 39.36, Winter_Melon = 7.2, Cucumber = 13.8, Luffa = 20.75,
  Bitter_Melon = 32.4, Pumpkin = 18.7, Tomato = 14, Chili_Pepper = 36.8, Eggplant = 24.225,
  Green_Pepper = 41.86, Wood_Ear_Mushroom = 36, Enoki_Mushroom = 71, Mushroom = 35.64,
  Shiitake_Mushroom = 63, Kelp = 33, Apple = 12.75, Banana = 18.2, Orange = 10.36, Pomelo = 28.29,
  Pear = 5.74, Peach = 15.13, Mango = 8.4, Muskmelon = 7.02, Grape = 8.6, Persimmon = 5.52, Longan = 14,
  Lychee = 10.95, Loquat = 11.16, Watermelon = 5.9, Strawberry = 16.49, Kiwi = 16.6, Water_Chestnut = 28.08,
  Dried_Shiitake = 398.05, Dried_Kelp = 32.34, Dried_Seaweed = 713, Dried_Scallop = 1503, Dried_Fish = 1450)
  )

  df$threonine <- calc_sparse_nutrient(
c(rice = 100, White_Congee = 50, Rice_Noodles = 248, Noodles = 170, Macaroni_Pasta = 335, Oatmeal = 415,
  Deep_fried_dough_sticks = 165, Fish_balls = 510, Cuttlefish_Balls = 560, Sweet_Potato = 49.02, Taro = 92,
  Salted_Duck_Egg = 596.4, Century_Egg = 655.2, Pork_Floss = 1055, Ham_Sausage = 623.75,
  Chicken_Egg = 511.56, Duck_Egg = 603.78, Pork = 640.64, Pork_Chops = 484.035, Beef = 893, Mutton = 932,
  Rabbit_Meat = 835, Chicken = 555.66, Duck = 467.16, Pork_Tripe = 549.12, Pork_Liver = 800,
  Pork_Trotters = 300, Chicken_Gizzard = 818, Chicken_Wings = 510.6, Chicken_Feet = 400.8,
  Grass_Carp = 398.46, Silver_Carp = 448.96, Crucian_Carp = 399.06, Perch = 530.7, Yellow_Croaker = 496.64,
  Sardine = 435.5, Black_Carp = 521.64, Mackerel = 303.31, Spanish_Mackerel = 723.24, Pomfret = 517.3,
  Hairtail = 546.44, Mandarin_Fish = 582.55, Dike_Fish = 499.2, Bream = 542.21, Rice_Eel = 516.57,
  Squid = 701.31, Crab = 978, Sea_Shrimp = 431.88, Clam = 184.47, Oyster = 225, Razor_Clam = 172.14,
  Mussel = 244.02, Jellyfish = 153.5, Fresh_Milk_Boxed_Milk = 127, Milk_Powder = 1161, Yogurt = 106,
  Soy_Milk = 63, Breakfast_Milk_Breakfast_Drink = 113, Peanuts = 125.08, Other_Nuts = 365.629018,
  Soybeans = 1435, Mung_Beans = 779, Tofu = 256, Dried_Tofu = 643, Tofu_Skin = 2200, Tofu_Strips = 484,
  Fried_Tofu = 581, Soybean_Sprouts = 141, Mung_Bean_Sprouts = 64, Snow_Peas = 56.32,
  White_Radish_Leaves = 173, Carrot_Leaves = 150, Carrot = 32.64, White_Radish = 21.85, Lotus_Root = 51.92,
  Bamboo_Shoots = 47.88, Bokchoy = 53.58, Chinese_Cabbage = 36.49, Onion = 25.2, Garlic = 92.65,
  Amaranth = 91.02, Chinese_Chives = 73.8, Water_Spinach = 68, Spinach = 101.46, Mustard_Greens = 76.14,
  Shepherds_Purse = 104.72, Rapeseed = 48.96, Winter_Melon = 5.6, Cucumber = 18.4, Luffa = 23.24,
  Bitter_Melon = 55.08, Pumpkin = 16.15, Tomato = 20, Chili_Pepper = 40.8, Eggplant = 30.4,
  Green_Pepper = 46.41, Wood_Ear_Mushroom = 63, Enoki_Mushroom = 75, Mushroom = 72.27,
  Shiitake_Mushroom = 83, Kelp = 40, Apple = 9.35, Banana = 34.3, Orange = 11.1, Pomelo = 33.12, Pear = 5.74,
  Peach = 23.14, Mango = 12, Pineapple = 14.96, Muskmelon = 9.36, Grape = 11.18, Persimmon = 14.72,
  Longan = 49, Lychee = 69.35, Loquat = 16.12, Watermelon = 7.67, Strawberry = 26.19, Kiwi = 19.92,
  Water_Chestnut = 27.3, Dried_Shiitake = 703.95, Dried_Kelp = 39.2, Dried_Seaweed = 1103,
  Dried_Scallop = 1963, Dried_Fish = 2026)
  )

  df$tryptophan <- calc_sparse_nutrient(
c(rice = 30, White_Congee = 10, Rice_Noodles = 110, Noodles = 98, Macaroni_Pasta = 131, Oatmeal = 131,
  Deep_fried_dough_sticks = 96, Fish_balls = 80, Cuttlefish_Balls = 90, Sweet_Potato = 20.64, Taro = 42,
  Potato = 27.26, Salted_Duck_Egg = 168, Century_Egg = 201.6, Pork_Floss = 363, Ham_Sausage = 181.5,
  Chicken_Egg = 162.69, Duck_Egg = 182.7, Pork = 113.75, Pork_Chops = 142.83, Beef = 125, Mutton = 143,
  Rabbit_Meat = 286, Chicken = 129.78, Duck = 144.84, Pork_Tripe = 90.24, Pork_Liver = 80,
  Pork_Trotters = 27.6, Chicken_Wings = 89.7, Chicken_Feet = 77.4, Grass_Carp = 98.6, Silver_Carp = 115.29,
  Crucian_Carp = 96.12, Perch = 104.98, Yellow_Croaker = 99.2, Sardine = 80.4, Black_Carp = 153.72,
  Mackerel = 100.94, Spanish_Mackerel = 187.92, Pomfret = 156.8, Hairtail = 157.32, Mandarin_Fish = 115.9,
  Dike_Fish = 131.2, Bream = 100.3, Rice_Eel = 167.5, Squid = 176.54, Sea_Shrimp = 129.8, Clam = 46.8,
  Oyster = 53, Razor_Clam = 50.73, Mussel = 76.93, Jellyfish = 17, Milk_Powder = 191, Yogurt = 57,
  Soy_Milk = 44, Peanuts = 60.42, Other_Nuts = 123.934821, Soybeans = 455, Mung_Beans = 246, Tofu = 93,
  Dried_Tofu = 220, Tofu_Skin = 700, Tofu_Strips = 218, Fried_Tofu = 234, Soybean_Sprouts = 56,
  Mung_Bean_Sprouts = 22, White_Radish_Leaves = 78, Carrot_Leaves = 80, Carrot = 9.6, White_Radish = 6.65,
  Lotus_Root = 22.88, Bamboo_Shoots = 22.68, Bokchoy = 21.62, Chinese_Cabbage = 9.79, Onion = 13.5,
  Garlic = 90.1, Amaranth = 25.9, Chinese_Chives = 25.2, Water_Spinach = 48, Spinach = 32.04,
  Shepherds_Purse = 39.6, Rapeseed = 22.08, Winter_Melon = 3.2, Cucumber = 5.52, Luffa = 7.47,
  Bitter_Melon = 10.53, Pumpkin = 8.5, Tomato = 5, Chili_Pepper = 16, Eggplant = 7.125, Green_Pepper = 18.2,
  Wood_Ear_Mushroom = 19, Enoki_Mushroom = 41, Mushroom = 31.68, Shiitake_Mushroom = 39, Kelp = 7,
  Apple = 9.35, Banana = 4.2, Orange = 2.22, Pomelo = 3.45, Pear = 7.38, Peach = 3.56, Pineapple = 1.36,
  Muskmelon = 1.56, Grape = 5.16, Longan = 5.5, Lychee = 3.65, Loquat = 1.24, Watermelon = 2.36,
  Strawberry = 8.73, Kiwi = 11.62, Water_Chestnut = 14.82, Dried_Shiitake = 210.9, Dried_Kelp = 6.86,
  Dried_Seaweed = 398, Dried_Scallop = 537, Dried_Fish = 654)
  )

  df$valine <- calc_sparse_nutrient(
c(rice = 170, White_Congee = 90, Rice_Noodles = 442, Noodles = 300, Macaroni_Pasta = 549, Oatmeal = 541,
  Fish_balls = 500, Cuttlefish_Balls = 540, Sweet_Potato = 61.06, Taro = 112, Potato = 81.78,
  Salted_Duck_Egg = 613.2, Century_Egg = 729.9, Pork_Floss = 1295, Ham_Sausage = 681.5, Chicken_Egg = 553.32,
  Duck_Egg = 628.14, Pork = 661.57, Pork_Chops = 501.63, Beef = 936, Mutton = 992, Rabbit_Meat = 1008,
  Chicken = 574.56, Duck = 520.88, Pork_Tripe = 628.8, Pork_Liver = 910, Pork_Trotters = 375,
  Chicken_Gizzard = 869, Chicken_Wings = 524.4, Chicken_Feet = 450.6, Grass_Carp = 521.42,
  Silver_Carp = 535.58, Crucian_Carp = 465.48, Perch = 582.32, Yellow_Croaker = 539.84, Sardine = 475.7,
  Black_Carp = 607.32, Mackerel = 360.15, Spanish_Mackerel = 774.72, Pomfret = 625.8, Hairtail = 615.6,
  Mandarin_Fish = 581.33, Dike_Fish = 594.56, Bream = 551.65, Rice_Eel = 565.48, Squid = 693.55, Crab = 1006,
  Sea_Shrimp = 496.19, Clam = 182.91, Oyster = 248, Razor_Clam = 161.31, Mussel = 237.65, Jellyfish = 177,
  Fresh_Milk_Boxed_Milk = 158, Milk_Powder = 1189, Yogurt = 136, Soy_Milk = 83,
  Breakfast_Milk_Breakfast_Drink = 148, Peanuts = 205.64, Other_Nuts = 525.551786, Soybeans = 1726,
  Mung_Beans = 1189, Tofu = 296, Dried_Tofu = 883, Tofu_Skin = 2440, Tofu_Strips = 883, Fried_Tofu = 825,
  Soybean_Sprouts = 199, Mung_Bean_Sprouts = 127, Snow_Peas = 64.24, White_Radish_Leaves = 221,
  Carrot_Leaves = 198, Carrot = 51.84, White_Radish = 29.45, Lotus_Root = 50.16, Bamboo_Shoots = 66.78,
  Bokchoy = 70.5, Chinese_Cabbage = 47.17, Onion = 39.6, Garlic = 130.05, Amaranth = 168.72,
  Chinese_Chives = 73.8, Water_Spinach = 85, Spinach = 106.8, Mustard_Greens = 122.2,
  Shepherds_Purse = 128.48, Rapeseed = 60.48, Winter_Melon = 11.2, Cucumber = 21.16, Luffa = 30.71,
  Bitter_Melon = 45.36, Pumpkin = 22.1, Tomato = 15, Chili_Pepper = 46.4, Eggplant = 45.125,
  Green_Pepper = 52.78, Wood_Ear_Mushroom = 58, Enoki_Mushroom = 85, Mushroom = 99, Shiitake_Mushroom = 95,
  Kelp = 57, Apple = 17.85, Banana = 50.4, Orange = 14.8, Pomelo = 28.29, Pear = 8.2, Peach = 29.37,
  Mango = 12, Pineapple = 3.4, Muskmelon = 10.92, Grape = 11.18, Persimmon = 14.72, Longan = 23.5,
  Lychee = 22.63, Watermelon = 11.8, Strawberry = 28.13, Kiwi = 28.22, Water_Chestnut = 38.22,
  Dried_Shiitake = 654.55, Dried_Kelp = 55.86, Dried_Seaweed = 1375, Dried_Scallop = 2218, Dried_Fish = 2364)
  )

  df$arginine <- calc_sparse_nutrient(
c(rice = 210, White_Congee = 100, Rice_Noodles = 519, Noodles = 242, Macaroni_Pasta = 432, Oatmeal = 702,
  Deep_fried_dough_sticks = 254, Fish_balls = 700, Cuttlefish_Balls = 710, Sweet_Potato = 61.06, Taro = 109,
  Potato = 66.74, Salted_Duck_Egg = 571.2, Century_Egg = 678.6, Pork_Floss = 1431, Ham_Sausage = 926,
  Chicken_Egg = 646.41, Duck_Egg = 602.91, Pork = 920.92, Pork_Chops = 716.565, Beef = 1262, Mutton = 1225,
  Rabbit_Meat = 1351, Chicken = 850.5, Duck = 633.76, Pork_Tripe = 910.08, Pork_Liver = 1060,
  Pork_Trotters = 1092, Chicken_Gizzard = 1344, Chicken_Wings = 821.1, Chicken_Feet = 1243.2,
  Grass_Carp = 560.28, Silver_Carp = 646.6, Crucian_Carp = 556.74, Perch = 832.3, Yellow_Croaker = 684.16,
  Sardine = 502.5, Black_Carp = 678.51, Mackerel = 434.14, Spanish_Mackerel = 838.44, Pomfret = 777.7,
  Hairtail = 791.92, Mandarin_Fish = 761.28, Dike_Fish = 729.6, Bream = 743.99, Rice_Eel = 871,
  Squid = 973.88, Crab = 1926, Sea_Shrimp = 1099.76, Clam = 292.5, Razor_Clam = 262.2, Mussel = 364.07,
  Jellyfish = 355.5, Fresh_Milk_Boxed_Milk = 82, Milk_Powder = 715, Yogurt = 84, Soy_Milk = 135,
  Breakfast_Milk_Breakfast_Drink = 73, Other_Nuts = 1339.433036, Soybeans = 2840, Mung_Beans = 1577,
  Tofu = 487, Dried_Tofu = 1260, Tofu_Skin = 3750, Tofu_Strips = 1440, Fried_Tofu = 1382,
  Soybean_Sprouts = 247, Mung_Bean_Sprouts = 130, Snow_Peas = 96.8, White_Radish_Leaves = 139,
  Carrot_Leaves = 95, Carrot = 40.32, White_Radish = 33.25, Lotus_Root = 42.24, Bamboo_Shoots = 64.26,
  Bokchoy = 61.1, Chinese_Cabbage = 50.73, Onion = 143.1, Garlic = 765.85, Amaranth = 127.28,
  Chinese_Chives = 81, Water_Spinach = 94, Spinach = 119.26, Mustard_Greens = 87.42, Shepherds_Purse = 80.96,
  Rapeseed = 65.28, Winter_Melon = 15.2, Cucumber = 18.4, Luffa = 41.5, Bitter_Melon = 72.9, Pumpkin = 24.65,
  Tomato = 18, Chili_Pepper = 37.6, Eggplant = 49.875, Green_Pepper = 42.77, Wood_Ear_Mushroom = 69,
  Enoki_Mushroom = 63, Mushroom = 82.17, Shiitake_Mushroom = 71, Kelp = 66, Apple = 7.65, Banana = 42,
  Orange = 48.84, Pomelo = 17.25, Pear = 4.92, Peach = 26.7, Mango = 18, Pineapple = 14.96,
  Muskmelon = 17.94, Grape = 32.68, Persimmon = 15.64, Longan = 29, Lychee = 16.06, Loquat = 14.88,
  Watermelon = 38.94, Strawberry = 41.71, Kiwi = 24.9, Water_Chestnut = 78.78, Dried_Shiitake = 807.5,
  Dried_Kelp = 64.68, Dried_Seaweed = 1478, Dried_Scallop = 5058, Dried_Fish = 2786)
  )

  df$histidine <- calc_sparse_nutrient(
c(rice = 60, White_Congee = 30, Rice_Noodles = 190, Noodles = 118, Macaroni_Pasta = 226, Oatmeal = 264,
  Deep_fried_dough_sticks = 147, Fish_balls = 200, Cuttlefish_Balls = 250, Sweet_Potato = 23.22, Taro = 40,
  Potato = 25.38, Salted_Duck_Egg = 226.8, Century_Egg = 311.4, Pork_Floss = 812, Ham_Sausage = 509,
  Chicken_Egg = 231.42, Duck_Egg = 222.72, Pork = 512.33, Pork_Chops = 372.6, Beef = 692, Mutton = 556,
  Rabbit_Meat = 632, Chicken = 367.29, Duck = 293.76, Pork_Tripe = 268.8, Pork_Liver = 460,
  Pork_Trotters = 270, Chicken_Gizzard = 421, Chicken_Wings = 317.4, Chicken_Feet = 186, Grass_Carp = 258.1,
  Silver_Carp = 283.65, Crucian_Carp = 225.72, Perch = 233.74, Yellow_Croaker = 221.76, Sardine = 341.7,
  Black_Carp = 379.89, Mackerel = 359.66, Spanish_Mackerel = 763.56, Pomfret = 242.9, Hairtail = 275.88,
  Mandarin_Fish = 266.57, Dike_Fish = 548.48, Bream = 302.67, Rice_Eel = 274.03, Squid = 292.94, Crab = 572,
  Sea_Shrimp = 236, Clam = 101.4, Razor_Clam = 57.57, Mussel = 95.55, Jellyfish = 23.5,
  Fresh_Milk_Boxed_Milk = 70, Milk_Powder = 553, Yogurt = 65, Soy_Milk = 41,
  Breakfast_Milk_Breakfast_Drink = 72, Peanuts = 138.86, Other_Nuts = 232.643973, Soybeans = 968,
  Mung_Beans = 647, Tofu = 161, Dried_Tofu = 392, Tofu_Skin = 1260, Tofu_Strips = 403, Fried_Tofu = 375,
  Soybean_Sprouts = 107, Mung_Bean_Sprouts = 53, Snow_Peas = 44.88, White_Radish_Leaves = 75,
  Carrot_Leaves = 65, Carrot = 13.44, White_Radish = 12.35, Lotus_Root = 28.16, Bamboo_Shoots = 27.09,
  Bokchoy = 24.44, Chinese_Cabbage = 17.8, Onion = 14.4, Garlic = 53.55, Amaranth = 46.62,
  Chinese_Chives = 27, Water_Spinach = 23, Spinach = 49.84, Mustard_Greens = 35.72, Shepherds_Purse = 78.32,
  Rapeseed = 29.76, Winter_Melon = 4, Cucumber = 9.2, Luffa = 14.94, Bitter_Melon = 18.63, Pumpkin = 9.35,
  Tomato = 12, Chili_Pepper = 16, Eggplant = 19.475, Green_Pepper = 18.2, Wood_Ear_Mushroom = 32,
  Enoki_Mushroom = 30, Mushroom = 35.64, Shiitake_Mushroom = 38, Kelp = 13, Apple = 4.25, Banana = 62.3,
  Orange = 6.66, Pomelo = 12.42, Pear = 4.1, Peach = 17.8, Mango = 16.8, Pineapple = 8.84, Muskmelon = 4.68,
  Grape = 6.88, Persimmon = 5.52, Longan = 15.5, Lychee = 12.41, Loquat = 8.68, Watermelon = 5.31,
  Strawberry = 14.55, Kiwi = 9.96, Water_Chestnut = 17.16, Dried_Shiitake = 270.75, Dried_Kelp = 12.74,
  Dried_Seaweed = 225, Dried_Scallop = 953, Dried_Fish = 884)
  )

  df$alanine <- calc_sparse_nutrient(
c(rice = 160, White_Congee = 70, Rice_Noodles = 417, Noodles = 210, Macaroni_Pasta = 376, Oatmeal = 568,
  Deep_fried_dough_sticks = 230, Fish_balls = 650, Cuttlefish_Balls = 660, Sweet_Potato = 50.74, Taro = 115,
  Potato = 56.4, Salted_Duck_Egg = 495.6, Century_Egg = 602.1, Pork_Floss = 1289, Ham_Sausage = 818.75,
  Chicken_Egg = 572.46, Duck_Egg = 507.21, Pork = 831.74, Pork_Chops = 639.285, Beef = 1152, Mutton = 1248,
  Rabbit_Meat = 1135, Chicken = 754.11, Duck = 615.4, Pork_Tripe = 831.36, Pork_Liver = 1160,
  Pork_Trotters = 1212, Chicken_Gizzard = 1036, Chicken_Wings = 759, Chicken_Feet = 1518.6,
  Grass_Carp = 583.48, Silver_Carp = 600.24, Crucian_Carp = 525.42, Yellow_Croaker = 668.8, Sardine = 556.1,
  Black_Carp = 740.25, Mackerel = 392.49, Spanish_Mackerel = 989.28, Pomfret = 762.3, Hairtail = 791.92,
  Mandarin_Fish = 771.65, Dike_Fish = 614.4, Bream = 735.14, Rice_Eel = 755.76, Squid = 838.08, Crab = 1356,
  Sea_Shrimp = 762.28, Clam = 202.41, Oyster = 287, Razor_Clam = 345.99, Mussel = 256.27, Jellyfish = 270,
  Fresh_Milk_Boxed_Milk = 86, Milk_Powder = 690, Yogurt = 82, Soy_Milk = 59,
  Breakfast_Milk_Breakfast_Drink = 74, Peanuts = 216.24, Other_Nuts = 528.320089, Soybeans = 1542,
  Mung_Beans = 999, Tofu = 280, Dried_Tofu = 724, Tofu_Skin = 2280, Tofu_Strips = 718, Fried_Tofu = 679,
  Soybean_Sprouts = 185, Mung_Bean_Sprouts = 66, Snow_Peas = 105.6, White_Radish_Leaves = 170,
  Carrot_Leaves = 134, Carrot = 54.72, White_Radish = 24.7, Lotus_Root = 71.28, Bamboo_Shoots = 66.78,
  Bokchoy = 76.14, Chinese_Cabbage = 58.74, Onion = 29.7, Garlic = 102.85, Amaranth = 137.64,
  Chinese_Chives = 115.2, Water_Spinach = 106, Spinach = 119.26, Mustard_Greens = 100.58,
  Shepherds_Purse = 128.48, Rapeseed = 74.88, Winter_Melon = 6.4, Cucumber = 21.16, Luffa = 35.69,
  Bitter_Melon = 39.69, Pumpkin = 32.3, Tomato = 17, Chili_Pepper = 40, Eggplant = 38.95,
  Green_Pepper = 45.5, Wood_Ear_Mushroom = 82, Enoki_Mushroom = 116, Mushroom = 157.41,
  Shiitake_Mushroom = 96, Kelp = 68, Apple = 11.9, Banana = 30.8, Orange = 17.02, Pomelo = 33.12,
  Pear = 4.92, Peach = 25.81, Mango = 36, Muskmelon = 21.84, Grape = 15.48, Persimmon = 14.72, Longan = 53.5,
  Lychee = 66.43, Loquat = 21.08, Watermelon = 8.85, Strawberry = 49.47, Kiwi = 33.2, Water_Chestnut = 31.98,
  Dried_Shiitake = 757.15, Dried_Kelp = 66.64, Dried_Seaweed = 2207, Dried_Scallop = 2105, Dried_Fish = 2634)
  )

  df$aspartic_acid <- calc_sparse_nutrient(
c(rice = 260, White_Congee = 120, Rice_Noodles = 682, Noodles = 267, Macaroni_Pasta = 505, Oatmeal = 925,
  Deep_fried_dough_sticks = 262, Fish_balls = 1100, Cuttlefish_Balls = 1210, Sweet_Potato = 187.48,
  Taro = 293, Potato = 334.64, Salted_Duck_Egg = 966, Century_Egg = 1060.2, Pork_Floss = 2157,
  Ham_Sausage = 1292.5, Chicken_Egg = 1054.44, Duck_Egg = 950.91, Pork = 1255.8, Pork_Chops = 975.66,
  Beef = 1725, Mutton = 1832, Rabbit_Meat = 1708, Chicken = 1162.35, Duck = 932.96, Pork_Tripe = 1116.48,
  Pork_Liver = 1640, Pork_Trotters = 900, Chicken_Gizzard = 1698, Chicken_Wings = 1090.2,
  Chicken_Feet = 1029, Grass_Carp = 891.46, Silver_Carp = 1067.5, Crucian_Carp = 950.94, Perch = 704.7,
  Yellow_Croaker = 1092.8, Sardine = 931.3, Black_Carp = 1123.92, Mackerel = 653.66,
  Spanish_Mackerel = 1469.52, Pomfret = 1173.2, Hairtail = 1228.16, Mandarin_Fish = 1234.03,
  Dike_Fish = 842.88, Bream = 1249.03, Rice_Eel = 1097.46, Squid = 1618.93, Crab = 2070, Sea_Shrimp = 985.3,
  Clam = 317.85, Oyster = 521, Razor_Clam = 372.21, Mussel = 447.37, Jellyfish = 404.5,
  Fresh_Milk_Boxed_Milk = 231, Milk_Powder = 1632, Yogurt = 188, Soy_Milk = 186,
  Breakfast_Milk_Breakfast_Drink = 194, Peanuts = 585.65, Other_Nuts = 1190.051116, Soybeans = 3997,
  Mung_Beans = 2671, Tofu = 770, Dried_Tofu = 2022, Tofu_Skin = 6080, Tofu_Strips = 1694, Fried_Tofu = 1816,
  Soybean_Sprouts = 879, Mung_Bean_Sprouts = 505, Snow_Peas = 482.24, White_Radish_Leaves = 397,
  Carrot_Leaves = 358, Carrot = 120.96, White_Radish = 46.55, Lotus_Root = 504.24, Bamboo_Shoots = 178.29,
  Bokchoy = 122.2, Chinese_Cabbage = 93.45, Onion = 77.4, Garlic = 331.5, Amaranth = 225.7,
  Chinese_Chives = 154.8, Water_Spinach = 173, Spinach = 200.25, Mustard_Greens = 151.34,
  Shepherds_Purse = 226.16, Rapeseed = 160.32, Winter_Melon = 24.8, Cucumber = 30.36, Luffa = 71.38,
  Bitter_Melon = 34.83, Pumpkin = 68.85, Tomato = 84, Chili_Pepper = 165.6, Eggplant = 110.2,
  Green_Pepper = 188.37, Wood_Ear_Mushroom = 118, Enoki_Mushroom = 105, Mushroom = 164.34,
  Shiitake_Mushroom = 143, Kelp = 88, Apple = 57.8, Banana = 109.9, Orange = 67.34, Pomelo = 126.96,
  Pear = 18.86, Peach = 98.79, Mango = 26.4, Pineapple = 67.32, Muskmelon = 31.98, Grape = 17.2,
  Persimmon = 29.44, Longan = 78, Lychee = 94.17, Loquat = 95.48, Watermelon = 19.47, Strawberry = 170.72,
  Water_Chestnut = 262.86, Dried_Shiitake = 1378.45, Dried_Kelp = 86.24, Dried_Seaweed = 2089,
  Dried_Scallop = 5288, Dried_Fish = 4633)
  )

  df$glutamic_acid <- calc_sparse_nutrient(
c(rice = 520, White_Congee = 250, Rice_Noodles = 1470, Noodles = 1947, Macaroni_Pasta = 3168, Oatmeal = 2338,
  Deep_fried_dough_sticks = 2735, Fish_balls = 2290, Cuttlefish_Balls = 2510, Sweet_Potato = 103.2,
  Taro = 254, Potato = 253.8, Salted_Duck_Egg = 1344, Century_Egg = 1639.8, Pork_Floss = 4202,
  Ham_Sausage = 2181.75, Chicken_Egg = 1385.91, Duck_Egg = 1410.27, Pork = 2074.8, Pork_Chops = 1652.205,
  Beef = 2832, Mutton = 2974, Rabbit_Meat = 2913, Chicken = 1940.4, Duck = 1628.6, Pork_Tripe = 1942.08,
  Pork_Liver = 2330, Pork_Trotters = 1512, Chicken_Gizzard = 3021, Chicken_Wings = 1821.6,
  Chicken_Feet = 1753.8, Grass_Carp = 1412.88, Silver_Carp = 1717.76, Crucian_Carp = 1371.06,
  Perch = 1483.64, Yellow_Croaker = 1731.84, Sardine = 1427.1, Black_Carp = 1757.07, Mackerel = 930.02,
  Spanish_Mackerel = 2013.84, Pomfret = 1846.6, Hairtail = 2028.44, Mandarin_Fish = 2072.17,
  Dike_Fish = 1431.04, Bream = 1968.24, Rice_Eel = 1792.92, Squid = 2654.89, Crab = 3134,
  Sea_Shrimp = 1778.85, Clam = 452.4, Oyster = 766, Razor_Clam = 552.9, Mussel = 617.4, Jellyfish = 612.5,
  Fresh_Milk_Boxed_Milk = 632, Milk_Powder = 3665, Yogurt = 509, Soy_Milk = 284,
  Breakfast_Milk_Breakfast_Drink = 535, Peanuts = 971.49, Other_Nuts = 2185.149777, Soybeans = 6258,
  Mung_Beans = 4188, Tofu = 1259, Dried_Tofu = 3322, Tofu_Skin = 9710, Tofu_Strips = 2936, Fried_Tofu = 3107,
  Soybean_Sprouts = 426, Mung_Bean_Sprouts = 121, Snow_Peas = 431.2, White_Radish_Leaves = 498,
  Carrot_Leaves = 478, Carrot = 220.8, White_Radish = 100.7, Lotus_Root = 185.68, Bamboo_Shoots = 155.61,
  Bokchoy = 212.44, Chinese_Cabbage = 328.41, Onion = 252.9, Garlic = 609.45, Amaranth = 256.78,
  Chinese_Chives = 271.8, Water_Spinach = 182, Spinach = 296.37, Mustard_Greens = 241.58,
  Shepherds_Purse = 258.72, Rapeseed = 206.4, Winter_Melon = 88.8, Cucumber = 188.6, Luffa = 131.97,
  Bitter_Melon = 78.57, Pumpkin = 89.25, Tomato = 311, Chili_Pepper = 168.8, Eggplant = 159.125,
  Green_Pepper = 192.01, Wood_Ear_Mushroom = 133, Enoki_Mushroom = 245, Mushroom = 398.97,
  Shiitake_Mushroom = 284, Kelp = 122, Apple = 25.5, Banana = 120.4, Orange = 37.74, Pomelo = 55.89,
  Pear = 8.2, Peach = 62.3, Mango = 48.6, Pineapple = 40.8, Muskmelon = 87.36, Grape = 39.56,
  Persimmon = 32.2, Longan = 89, Lychee = 100.01, Loquat = 59.52, Watermelon = 56.64, Kiwi = 73.04,
  Water_Chestnut = 59.28, Dried_Shiitake = 2716.05, Dried_Kelp = 119.56, Dried_Seaweed = 2082,
  Dried_Scallop = 8710, Dried_Fish = 10617)
  )

  df$glycine <- calc_sparse_nutrient(
c(rice = 130, White_Congee = 60, Rice_Noodles = 346, Noodles = 229, Macaroni_Pasta = 462, Oatmeal = 589,
  Deep_fried_dough_sticks = 264, Fish_balls = 590, Cuttlefish_Balls = 450, Sweet_Potato = 41.28, Taro = 114,
  Potato = 48.88, Salted_Duck_Egg = 327.6, Century_Egg = 423, Pork_Floss = 1039, Ham_Sausage = 730.25,
  Chicken_Egg = 342.78, Duck_Egg = 354.96, Pork = 706.16, Pork_Chops = 602.37, Beef = 988, Mutton = 1026,
  Rabbit_Meat = 909, Chicken = 583.38, Duck = 540.6, Pork_Tripe = 1278.72, Pork_Liver = 1150,
  Pork_Trotters = 2958, Chicken_Gizzard = 1214, Chicken_Wings = 752.1, Chicken_Feet = 338.4,
  Grass_Carp = 544.62, Silver_Carp = 547.17, Crucian_Carp = 528.66, Perch = 779.52, Yellow_Croaker = 558.72,
  Sardine = 475.7, Black_Carp = 578.97, Mackerel = 316.05, Spanish_Mackerel = 867.24, Pomfret = 760.2,
  Hairtail = 844.36, Mandarin_Fish = 680.15, Dike_Fish = 554.88, Bream = 715.67, Rice_Eel = 824.77,
  Squid = 808.98, Crab = 1145, Sea_Shrimp = 1142.24, Clam = 196.95, Oyster = 324, Razor_Clam = 256.5,
  Mussel = 311.64, Jellyfish = 827.5, Fresh_Milk_Boxed_Milk = 46, Milk_Powder = 424, Yogurt = 46,
  Soy_Milk = 72, Breakfast_Milk_Breakfast_Drink = 44, Peanuts = 314.82, Other_Nuts = 533.004911,
  Soybeans = 1600, Mung_Beans = 886, Tofu = 264, Dried_Tofu = 702, Tofu_Skin = 2150, Tofu_Strips = 637,
  Fried_Tofu = 635, Soybean_Sprouts = 126, Mung_Bean_Sprouts = 41, Snow_Peas = 37.84,
  White_Radish_Leaves = 166, Carrot_Leaves = 144, Carrot = 29.76, White_Radish = 16.15, Lotus_Root = 33.44,
  Bamboo_Shoots = 53.55, Bokchoy = 62.98, Chinese_Cabbage = 35.6, Onion = 29.7, Garlic = 100.3,
  Amaranth = 129.5, Chinese_Chives = 90, Water_Spinach = 84, Spinach = 120.15, Mustard_Greens = 91.18,
  Shepherds_Purse = 117.92, Rapeseed = 53.76, Winter_Melon = 6.4, Cucumber = 24.84, Luffa = 25.73,
  Bitter_Melon = 31.59, Pumpkin = 18.7, Tomato = 14, Chili_Pepper = 44, Eggplant = 33.25,
  Green_Pepper = 50.05, Wood_Ear_Mushroom = 58, Enoki_Mushroom = 66, Mushroom = 86.13,
  Shiitake_Mushroom = 78, Kelp = 65, Apple = 10.2, Banana = 30.1, Orange = 13.32, Pomelo = 15.87,
  Pear = 4.92, Peach = 33.82, Mango = 11.4, Pineapple = 15.64, Muskmelon = 11.7, Grape = 9.46,
  Persimmon = 12.88, Longan = 17, Lychee = 26.28, Loquat = 16.12, Watermelon = 7.08, Strawberry = 30.07,
  Kiwi = 21.58, Water_Chestnut = 28.86, Dried_Shiitake = 641.25, Dried_Kelp = 63.7, Dried_Seaweed = 1389,
  Dried_Scallop = 6773, Dried_Fish = 1874)
  )

  df$proline <- calc_sparse_nutrient(
c(rice = 120, White_Congee = 60, Rice_Noodles = 404, Noodles = 1100, Macaroni_Pasta = 1565, Oatmeal = 671,
  Fish_balls = 410, Cuttlefish_Balls = 430, Sweet_Potato = 56.76, Taro = 83, Potato = 46.06,
  Salted_Duck_Egg = 386.4, Century_Egg = 442.8, Pork_Floss = 679, Ham_Sausage = 504.75, Chicken_Egg = 298.41,
  Duck_Egg = 345.39, Pork = 594.23, Pork_Chops = 455.745, Beef = 754, Mutton = 852, Rabbit_Meat = 752,
  Chicken = 594.72, Duck = 497.76, Pork_Tripe = 872.64, Pork_Liver = 880, Pork_Trotters = 1596,
  Chicken_Gizzard = 813, Chicken_Wings = 524.4, Chicken_Feet = 1677, Grass_Carp = 392.66,
  Silver_Carp = 451.4, Crucian_Carp = 340.2, Perch = 593.92, Yellow_Croaker = 354.24, Sardine = 388.6,
  Black_Carp = 422.1, Mackerel = 228.34, Spanish_Mackerel = 636.48, Pomfret = 469, Hairtail = 468.92,
  Mandarin_Fish = 369.66, Dike_Fish = 499.2, Bream = 437.19, Rice_Eel = 525.95, Squid = 678.03, Crab = 1084,
  Sea_Shrimp = 759.92, Clam = 134.16, Oyster = 240, Jellyfish = 281.5, Fresh_Milk_Boxed_Milk = 301,
  Milk_Powder = 2063, Yogurt = 211, Soy_Milk = 136, Breakfast_Milk_Breakfast_Drink = 226, Peanuts = 293.62,
  Other_Nuts = 516.501562, Soybeans = 1863, Mung_Beans = 999, Tofu = 320, Dried_Tofu = 661, Tofu_Skin = 2150,
  Tofu_Strips = 701, Fried_Tofu = 682, Soybean_Sprouts = 167, Mung_Bean_Sprouts = 66,
  White_Radish_Leaves = 220, Carrot_Leaves = 203, Carrot = 29.76, White_Radish = 13.3, Lotus_Root = 46.64,
  Bamboo_Shoots = 42.84, Bokchoy = 73.32, Chinese_Cabbage = 37.38, Garlic = 96.05, Amaranth = 89.54,
  Chinese_Chives = 81.9, Water_Spinach = 78, Spinach = 89.89, Mustard_Greens = 75.2, Shepherds_Purse = 90.64,
  Rapeseed = 170.88, Winter_Melon = 8, Cucumber = 20.24, Luffa = 20.75, Bitter_Melon = 71.28, Pumpkin = 15.3,
  Tomato = 17, Chili_Pepper = 46.4, Eggplant = 31.825, Green_Pepper = 52.78, Wood_Ear_Mushroom = 50,
  Enoki_Mushroom = 76, Mushroom = 99.99, Kelp = 58, Apple = 9.35, Banana = 34.3, Orange = 68.82,
  Pomelo = 40.71, Pear = 5.74, Peach = 30.26, Mango = 10.2, Pineapple = 17, Muskmelon = 7.8, Grape = 9.46,
  Persimmon = 13.8, Longan = 29, Lychee = 40.88, Loquat = 19.84, Watermelon = 6.49, Strawberry = 29.1,
  Kiwi = 26.56, Water_Chestnut = 14.04, Dried_Shiitake = 618.45, Dried_Kelp = 56.84, Dried_Seaweed = 757,
  Dried_Scallop = 2331, Dried_Fish = 1179)
  )

  df$serine <- calc_sparse_nutrient(
c(rice = 150, White_Congee = 70, Rice_Noodles = 392, Noodles = 307, Macaroni_Pasta = 599, Oatmeal = 533,
  Deep_fried_dough_sticks = 300, Fish_balls = 480, Cuttlefish_Balls = 520, Sweet_Potato = 60.2, Taro = 125,
  Salted_Duck_Egg = 814.8, Century_Egg = 915.3, Pork_Floss = 899, Ham_Sausage = 560.5, Chicken_Egg = 787.35,
  Duck_Egg = 852.6, Pork = 581.49, Pork_Chops = 425.04, Beef = 790, Mutton = 768, Rabbit_Meat = 733,
  Chicken = 546.84, Duck = 391, Pork_Tripe = 560.64, Pork_Liver = 870, Pork_Trotters = 502.8,
  Chicken_Gizzard = 730, Chicken_Wings = 469.2, Chicken_Feet = 469.2, Grass_Carp = 370.62,
  Silver_Carp = 400.16, Crucian_Carp = 346.14, Perch = 470.38, Yellow_Croaker = 451.84, Sardine = 388.6,
  Black_Carp = 447.93, Mackerel = 261.66, Spanish_Mackerel = 633.24, Pomfret = 445.9, Hairtail = 478.04,
  Mandarin_Fish = 529.48, Dike_Fish = 398.72, Bream = 479.08, Rice_Eel = 466.32, Squid = 638.26, Crab = 893,
  Sea_Shrimp = 421.85, Clam = 152.1, Oyster = 252, Razor_Clam = 169.86, Mussel = 225.4, Jellyfish = 168.5,
  Fresh_Milk_Boxed_Milk = 163, Milk_Powder = 1374, Yogurt = 130, Soy_Milk = 94,
  Breakfast_Milk_Breakfast_Drink = 137, Peanuts = 237.97, Other_Nuts = 493.503348, Soybeans = 1846,
  Mung_Beans = 1135, Tofu = 358, Dried_Tofu = 822, Tofu_Skin = 2790, Tofu_Strips = 838, Fried_Tofu = 784,
  Soybean_Sprouts = 173, Mung_Bean_Sprouts = 67, Snow_Peas = 95.04, White_Radish_Leaves = 149,
  Carrot_Leaves = 120, Carrot = 37.44, White_Radish = 17.1, Lotus_Root = 54.56, Bamboo_Shoots = 53.55,
  Bokchoy = 50.76, Chinese_Cabbage = 43.61, Onion = 28.8, Garlic = 109.65, Amaranth = 91.02,
  Chinese_Chives = 78.3, Water_Spinach = 74, Spinach = 90.78, Mustard_Greens = 65.8,
  Shepherds_Purse = 104.72, Rapeseed = 51.84, Winter_Melon = 7.2, Cucumber = 23.92, Luffa = 29.05,
  Bitter_Melon = 34.83, Pumpkin = 19.55, Tomato = 23, Chili_Pepper = 54.4, Eggplant = 33.25,
  Green_Pepper = 61.88, Wood_Ear_Mushroom = 58, Enoki_Mushroom = 67, Mushroom = 70.29,
  Shiitake_Mushroom = 86, Kelp = 44, Apple = 11.9, Banana = 35.7, Orange = 17.02, Pomelo = 25.53,
  Pear = 4.92, Peach = 20.47, Mango = 16.2, Pineapple = 20.4, Muskmelon = 11.7, Grape = 11.18,
  Persimmon = 12.88, Longan = 25, Lychee = 24.09, Loquat = 21.08, Watermelon = 8.26, Strawberry = 48.5,
  Kiwi = 18.26, Water_Chestnut = 49.14, Dried_Shiitake = 716.3, Dried_Kelp = 43.12, Dried_Seaweed = 1083,
  Dried_Scallop = 2268, Dried_Fish = 1756)
  )

  df$Fat <- calc_sparse_nutrient(
c(rice = 0.4, White_Congee = 0.2, Noodles = 0.466667, White_Steamed_Bread = 1.3,
  Deep_fried_dough_sticks = 17.6, Fish_balls = 1.3, Cuttlefish_Balls = 4.7, Sweet_Potato = 0.172,
  Salted_Duck_Egg = 11.34, Century_Egg = 9.63, Pork_Floss = 26, Ham_Sausage = 23.2, Chicken_Egg = 7.482,
  Duck_Egg = 11.31, Pork = 27.391, Pork_Chops = 20.01, Beef = 8.7, Mutton = 6.5, Rabbit_Meat = 2.1,
  Chicken = 5.922, Duck = 13.396, Pork_Tripe = 4.896, Pork_Liver = 4.7, Pork_Trotters = 10.74,
  Pork_Blood = 0.3, Chicken_Gizzard = 2.8, Chicken_Wings = 7.935, Chicken_Feet = 9.84, Grass_Carp = 3.016,
  Silver_Carp = 2.196, Crucian_Carp = 1.458, Perch = 1.972, Yellow_Croaker = 2.432, Eel = 9.072,
  Sardine = 0.737, Black_Carp = 2.646, Mackerel = 19.306, Spanish_Mackerel = 1.692, Pomfret = 5.11,
  Hairtail = 3.724, Mandarin_Fish = 2.562, Dike_Fish = 8.192, Bream = 3.717, Horse_Mackerel = 2.38,
  Rice_Eel = 0.938, Squid = 1.94, Crab = 1.2, Sea_Shrimp = 0.472, Clam = 0.429, Oyster = 2.1,
  Razor_Clam = 0.171, Mussel = 0.833, Jellyfish = 0.3, Fresh_Milk_Boxed_Milk = 3.7, Milk_Powder = 22.3,
  Yogurt = 2.6, Soy_Milk = 1.5, Breakfast_Milk_Breakfast_Drink = 3.2, Peanuts = 13.462,
  Other_Nuts = 31.303125, Soybeans = 16, Mung_Beans = 0.8, Soybean_Milk = 1.6, Tofu = 5.3, Dried_Tofu = 11.3,
  Tofu_Skin = 23, Tofu_Strips = 10.5, Fried_Tofu = 17.6, Soybean_Sprouts = 1.6, Mung_Bean_Sprouts = 0.1,
  Wood_Ear_Mushroom = 0.2, Mushroom = 0.099, Shiitake_Mushroom = 0.3, Dried_Shiitake = 1.14,
  Dried_Scallop = 2.4, Dried_Fish = 3.4)
  )

  df$fatty_acid_total <- calc_sparse_nutrient(
c(rice = 0.3, White_Congee = 0.2, Noodles = 0.3, White_Steamed_Bread = 0.9, Deep_fried_dough_sticks = 10.2,
  Fish_balls = 1.2, Cuttlefish_Balls = 4.2, Sweet_Potato = 0.172, Salted_Duck_Egg = 9.408,
  Century_Egg = 8.01, Pork_Floss = 23.7, Ham_Sausage = 21.1, Chicken_Egg = 6.264, Duck_Egg = 9.396,
  Pork = 24.297, Pork_Chops = 18.216, Beef = 8, Mutton = 7.4, Rabbit_Meat = 1.9, Chicken = 5.607,
  Duck = 12.648, Pork_Tripe = 4.416, Pork_Liver = 3.5, Pork_Trotters = 9.78, Pork_Blood = 0.3,
  Chicken_Gizzard = 2.6, Chicken_Wings = 7.521, Chicken_Feet = 9.3, Grass_Carp = 2.088, Silver_Carp = 1.525,
  Crucian_Carp = 1.026, Perch = 1.392, Yellow_Croaker = 1.728, Eel = 6.384, Sardine = 0.67,
  Black_Carp = 2.394, Mackerel = 13.524, Spanish_Mackerel = 1.188, Pomfret = 3.57, Hairtail = 2.584,
  Mandarin_Fish = 1.769, Dike_Fish = 5.76, Bream = 2.596, Horse_Mackerel = 1.68, Rice_Eel = 0.67,
  Squid = 1.422667, Crab = 0.8, Sea_Shrimp = 0.354, Clam = 0.312, Oyster = 1.5, Razor_Clam = 0.114,
  Mussel = 0.588, Jellyfish = 0.2, Fresh_Milk_Boxed_Milk = 3.5, Milk_Powder = 20.2, Yogurt = 2.3,
  Soy_Milk = 1.4, Breakfast_Milk_Breakfast_Drink = 3, Peanuts = 12.826, Other_Nuts = 29.936719,
  Soybeans = 14.9, Mung_Beans = 0.6, Soybean_Milk = 1.5, Tofu = 4.9, Dried_Tofu = 13.2, Tofu_Skin = 21.4,
  Tofu_Strips = 9.8, Fried_Tofu = 16.4, Soybean_Sprouts = 1.3, Mung_Bean_Sprouts = 0.1,
  Wood_Ear_Mushroom = 0.2, Mushroom = 0.099, Shiitake_Mushroom = 0.2, Dried_Shiitake = 0.95,
  Dried_Scallop = 1.7, Dried_Fish = 2.4)
  )

  df$fatty_acid_saturated <- calc_sparse_nutrient(
c(rice = 0.1, White_Congee = 0.1, Noodles = 0.1, White_Steamed_Bread = 0.7, Deep_fried_dough_sticks = 0.5,
  Fish_balls = 0.7, Cuttlefish_Balls = 1.9, Salted_Duck_Egg = 3.528, Century_Egg = 2.52, Pork_Floss = 8.2,
  Ham_Sausage = 8.4, Chicken_Egg = 4.002, Duck_Egg = 3.306, Pork = 9.828, Pork_Chops = 8.5215, Beef = 4.1,
  Mutton = 4.2, Rabbit_Meat = 0.75, Chicken = 1.953, Duck = 3.808, Pork_Tripe = 2.304, Pork_Liver = 2.1,
  Pork_Trotters = 3.21, Pork_Blood = 0.1, Chicken_Gizzard = 1, Chicken_Wings = 3.864, Chicken_Feet = 2.28,
  Grass_Carp = 0.58, Silver_Carp = 0.488, Crucian_Carp = 0.27, Perch = 0.464, Yellow_Croaker = 0.704,
  Eel = 2.352, Sardine = 0.201, Black_Carp = 0.945, Mackerel = 3.136, Spanish_Mackerel = 0.432,
  Pomfret = 1.47, Hairtail = 1.14, Mandarin_Fish = 0.549, Dike_Fish = 2.368, Bream = 0.708,
  Horse_Mackerel = 0.42, Rice_Eel = 0.201, Squid = 1.228667, Crab = 0.3, Sea_Shrimp = 0.118, Clam = 0.078,
  Oyster = 0.6, Razor_Clam = 0.057, Mussel = 0.294, Jellyfish = 0.1, Fresh_Milk_Boxed_Milk = 2.3,
  Milk_Powder = 12, Yogurt = 1.6, Soy_Milk = 0.2, Breakfast_Milk_Breakfast_Drink = 2, Peanuts = 2.544,
  Other_Nuts = 3.353906, Soybeans = 2.4, Mung_Beans = 0.2, Soybean_Milk = 0.8, Tofu = 2, Dried_Tofu = 3.6,
  Tofu_Skin = 5.6, Tofu_Strips = 1.5, Fried_Tofu = 3, Soybean_Sprouts = 0.3, Dried_Shiitake = 0.095,
  Dried_Scallop = 0.5, Dried_Fish = 0.6)
  )

  df$fatty_acid_monounsaturated <- calc_sparse_nutrient(
c(rice = 0.1, Noodles = 0.066667, White_Steamed_Bread = 0.2, Deep_fried_dough_sticks = 7.5, Fish_balls = 0.4,
  Cuttlefish_Balls = 1.8, Sweet_Potato = 0.086, Salted_Duck_Egg = 5.88, Century_Egg = 4.5, Pork_Floss = 13.1,
  Ham_Sausage = 10.3, Chicken_Egg = 1.653, Duck_Egg = 4.872, Pork = 12.103, Pork_Chops = 8.763, Beef = 3.5,
  Mutton = 2.4, Rabbit_Meat = 0.4, Chicken = 2.331, Duck = 6.324, Pork_Tripe = 1.728, Pork_Liver = 1.3,
  Pork_Trotters = 5.25, Pork_Blood = 0.1, Chicken_Gizzard = 1, Chicken_Wings = 3.519, Chicken_Feet = 5.04,
  Grass_Carp = 0.812, Silver_Carp = 0.61, Crucian_Carp = 0.432, Perch = 0.464, Yellow_Croaker = 0.864,
  Eel = 2.688, Sardine = 0.201, Black_Carp = 0.819, Mackerel = 6.125, Spanish_Mackerel = 0.432,
  Pomfret = 1.54, Hairtail = 0.988, Mandarin_Fish = 0.671, Dike_Fish = 1.472, Bream = 1.18,
  Horse_Mackerel = 0.77, Rice_Eel = 0.268, Squid = 0.064667, Crab = 0.2, Sea_Shrimp = 0.118, Clam = 0.039,
  Oyster = 0.3, Mussel = 0.147, Jellyfish = 0.1, Fresh_Milk_Boxed_Milk = 1, Milk_Powder = 6.2, Yogurt = 0.6,
  Soy_Milk = 0.3, Breakfast_Milk_Breakfast_Drink = 0.8, Peanuts = 4.929, Other_Nuts = 14.819297,
  Soybeans = 3.5, Mung_Beans = 0.1, Soybean_Milk = 0.5, Tofu = 1.8, Dried_Tofu = 4.2, Tofu_Skin = 6.5,
  Tofu_Strips = 2.1, Fried_Tofu = 3, Soybean_Sprouts = 0.4, Wood_Ear_Mushroom = 0.1, Dried_Shiitake = 0.095,
  Dried_Scallop = 1, Dried_Fish = 0.8)
  )

  df$fatty_acid_polyunsaturated <- calc_sparse_nutrient(
c(rice = 0.1, White_Congee = 0.1, Noodles = 0.133333, Deep_fried_dough_sticks = 2.2, Fish_balls = 0.1,
  Cuttlefish_Balls = 0.4, Sweet_Potato = 0.086, Century_Egg = 1.08, Pork_Floss = 2.3, Ham_Sausage = 2.2,
  Chicken_Egg = 0.435, Duck_Egg = 0.957, Pork = 1.911, Pork_Chops = 0.828, Beef = 0.3, Mutton = 0.8,
  Rabbit_Meat = 0.7, Chicken = 1.386, Duck = 2.448, Pork_Tripe = 0.384, Pork_Liver = 0.1,
  Pork_Trotters = 1.05, Pork_Blood = 0.1, Chicken_Gizzard = 0.6, Chicken_Wings = 0.069, Chicken_Feet = 2.04,
  Grass_Carp = 0.522, Silver_Carp = 0.305, Crucian_Carp = 0.27, Perch = 0.348, Yellow_Croaker = 0.128,
  Eel = 1.176, Sardine = 0.201, Black_Carp = 0.252, Mackerel = 4.263, Spanish_Mackerel = 0.216,
  Pomfret = 0.35, Hairtail = 0.304, Mandarin_Fish = 0.427, Dike_Fish = 1.728, Bream = 0.472,
  Horse_Mackerel = 0.42, Rice_Eel = 0.134, Squid = 0.129333, Crab = 0.3, Sea_Shrimp = 0.118, Clam = 0.156,
  Oyster = 0.5, Razor_Clam = 0.057, Mussel = 0.098, Fresh_Milk_Boxed_Milk = 0.1, Milk_Powder = 1.1,
  Yogurt = 0.1, Soy_Milk = 0.9, Breakfast_Milk_Breakfast_Drink = 0.1, Peanuts = 4.929,
  Other_Nuts = 11.788359, Soybeans = 9.1, Mung_Beans = 0.3, Soybean_Milk = 0.2, Tofu = 1.1, Dried_Tofu = 5.4,
  Tofu_Skin = 9.2, Tofu_Strips = 6.1, Fried_Tofu = 10.4, Soybean_Sprouts = 0.7, Wood_Ear_Mushroom = 0.1,
  Mushroom = 0.099, Shiitake_Mushroom = 0.2, Dried_Shiitake = 0.665, Dried_Scallop = 0.1, Dried_Fish = 0.9)
  )

  df$fatty_acid_unknown <- calc_sparse_nutrient(
c(Deep_fried_dough_sticks = 1.5, Pork_Floss = 0.1, Ham_Sausage = 0.1, Chicken_Egg = 0.087, Duck_Egg = 0.261,
  Pork = 0.455, Duck = 0.068, Pork_Trotters = 0.27, Grass_Carp = 0.232, Silver_Carp = 0.122, Perch = 0.058,
  Yellow_Croaker = 0.032, Eel = 0.252, Sardine = 0.067, Black_Carp = 0.378, Spanish_Mackerel = 0.144,
  Pomfret = 0.21, Hairtail = 0.152, Mandarin_Fish = 0.061, Dike_Fish = 0.192, Bream = 0.236,
  Horse_Mackerel = 0.07, Rice_Eel = 0.067, Crab = 0.1, Oyster = 0.1, Fresh_Milk_Boxed_Milk = 0.1,
  Milk_Powder = 0.9, Soy_Milk = 0.1, Breakfast_Milk_Breakfast_Drink = 0.1, Dried_Fish = 0.2)
  )

  df$SFA_total_pct <- calc_sparse_nutrient(
c(rice = 36.9, White_Congee = 39.3, Noodles = 45.033333, White_Steamed_Bread = 75.3,
  Deep_fried_dough_sticks = 4.4, Fish_balls = 59.4, Cuttlefish_Balls = 45.8, Sweet_Potato = 16.254,
  Salted_Duck_Egg = 31.332, Century_Egg = 28.08, Pork_Floss = 34.5, Ham_Sausage = 39.9, Chicken_Egg = 56.376,
  Duck_Egg = 30.363, Pork = 36.764, Pork_Chops = 32.3265, Beef = 51.7, Mutton = 56.8, Rabbit_Meat = 40.85,
  Chicken = 21.798, Duck = 20.536, Pork_Tripe = 48.96, Pork_Liver = 58.7, Pork_Trotters = 19.65,
  Pork_Blood = 49.4, Chicken_Gizzard = 39.4, Chicken_Wings = 35.673, Chicken_Feet = 14.88,
  Grass_Carp = 15.66, Silver_Carp = 19.276, Crucian_Carp = 15.66, Perch = 19.72, Yellow_Croaker = 25.856,
  Eel = 30.66, Sardine = 23.115, Black_Carp = 24.885, Mackerel = 11.319, Spanish_Mackerel = 27.288,
  Pomfret = 28.28, Hairtail = 34.124, Mandarin_Fish = 18.605, Dike_Fish = 26.112, Bream = 15.458,
  Horse_Mackerel = 18.41, Rice_Eel = 21.105, Squid = 63.502667, Crab = 34.1, Sea_Shrimp = 22.007,
  Clam = 10.53, Oyster = 37.2, Razor_Clam = 24.681, Mussel = 25.48, Jellyfish = 69.35,
  Fresh_Milk_Boxed_Milk = 64.4, Milk_Powder = 59.5, Yogurt = 70.7, Soy_Milk = 11.6,
  Breakfast_Milk_Breakfast_Drink = 65.9, Peanuts = 10.494, Other_Nuts = 8.732578, Soybeans = 16,
  Mung_Beans = 32, Soybean_Milk = 51.3, Tofu = 33.8, Dried_Tofu = 20.4, Tofu_Skin = 26.1, Tofu_Strips = 15.8,
  Fried_Tofu = 18.6, Soybean_Sprouts = 19.9, Mung_Bean_Sprouts = 30.4, Wood_Ear_Mushroom = 23.1,
  Mushroom = 23.265, Shiitake_Mushroom = 13.2, Dried_Shiitake = 12.54, Dried_Scallop = 31.7, Dried_Fish = 26)
  )

  df$FA_4_0 <- calc_sparse_nutrient(
c(Fresh_Milk_Boxed_Milk = 2, Breakfast_Milk_Breakfast_Drink = 2)
  )

  df$FA_6_0 <- calc_sparse_nutrient(
c(Fresh_Milk_Boxed_Milk = 1.7, Milk_Powder = 0.3, Yogurt = 0.2, Breakfast_Milk_Breakfast_Drink = 1.6)
  )

  df$FA_8_0 <- calc_sparse_nutrient(
c(Chicken_Egg = 0.174, Sea_Shrimp = 0.059, Fresh_Milk_Boxed_Milk = 1.1, Milk_Powder = 0.5, Yogurt = 0.3,
  Breakfast_Milk_Breakfast_Drink = 1.1)
  )

  df$FA_10_0 <- calc_sparse_nutrient(
c(Fish_balls = 1.3, Cuttlefish_Balls = 0.1, Pork_Trotters = 0.03, Sea_Shrimp = 0.059,
  Fresh_Milk_Boxed_Milk = 2.6, Milk_Powder = 2, Yogurt = 1.4, Breakfast_Milk_Breakfast_Drink = 2.5,
  Other_Nuts = 0.012422, Soybean_Milk = 0.2, Dried_Tofu = 2.3)
  )

  df$FA_11_0 <- calc_sparse_nutrient(
c(Chicken_Egg = 0.174, Rabbit_Meat = 0.4, Silver_Carp = 0.061, Hairtail = 0.076, Milk_Powder = 0.1)
  )

  df$FA_12_0 <- calc_sparse_nutrient(
c(rice = 1.6, White_Congee = 2.3, Noodles = 1.366667, White_Steamed_Bread = 1.6, Fish_balls = 0.8,
  Cuttlefish_Balls = 0.1, Sweet_Potato = 1.204, Ham_Sausage = 0.1, Chicken_Egg = 0.087, Pork = 0.546,
  Pork_Chops = 0.069, Pork_Liver = 0.5, Pork_Trotters = 0.18, Chicken_Gizzard = 0.1, Silver_Carp = 0.061,
  Crucian_Carp = 0.054, Yellow_Croaker = 0.096, Sardine = 2.211, Spanish_Mackerel = 0.396, Pomfret = 0.77,
  Hairtail = 0.532, Mandarin_Fish = 0.061, Dike_Fish = 2.496, Bream = 0.059, Horse_Mackerel = 0.07,
  Rice_Eel = 0.134, Crab = 0.1, Sea_Shrimp = 0.059, Mussel = 0.147, Jellyfish = 0.9,
  Fresh_Milk_Boxed_Milk = 3.1, Milk_Powder = 3.9, Yogurt = 8.6, Breakfast_Milk_Breakfast_Drink = 3.1,
  Mung_Beans = 0.2, Soybean_Milk = 0.2, Dried_Scallop = 1.3)
  )

  df$FA_13_0 <- calc_sparse_nutrient(
c(Fresh_Milk_Boxed_Milk = 0.2, Breakfast_Milk_Breakfast_Drink = 0.2, Shiitake_Mushroom = 0.1,
  Dried_Shiitake = 0.095)
  )

  df$FA_14_0 <- calc_sparse_nutrient(
c(rice = 0.9, White_Congee = 0.8, Noodles = 0.8, White_Steamed_Bread = 0.5, Fish_balls = 2,
  Cuttlefish_Balls = 2.1, Salted_Duck_Egg = 0.336, Century_Egg = 0.45, Pork_Floss = 1, Ham_Sausage = 2.2,
  Chicken_Egg = 8.352, Duck_Egg = 0.261, Pork = 1.365, Pork_Chops = 1.2075, Beef = 3.7, Mutton = 3.7,
  Rabbit_Meat = 1.4, Chicken = 0.567, Duck = 0.408, Pork_Tripe = 1.248, Pork_Liver = 1.8,
  Pork_Trotters = 0.81, Pork_Blood = 0.8, Chicken_Gizzard = 0.6, Chicken_Wings = 0.69, Chicken_Feet = 0.3,
  Grass_Carp = 0.754, Silver_Carp = 2.013, Crucian_Carp = 1.296, Perch = 1.682, Yellow_Croaker = 2.848,
  Eel = 2.772, Sardine = 2.211, Black_Carp = 1.638, Mackerel = 4.459, Spanish_Mackerel = 1.44,
  Pomfret = 2.66, Hairtail = 4.028, Mandarin_Fish = 1.525, Bream = 1.239, Horse_Mackerel = 1.61,
  Rice_Eel = 1.943, Squid = 1.713667, Crab = 2.5, Sea_Shrimp = 0.826, Clam = 0.468, Oyster = 5.4,
  Razor_Clam = 3.477, Mussel = 4.263, Jellyfish = 4.55, Fresh_Milk_Boxed_Milk = 10.1, Milk_Powder = 11.6,
  Yogurt = 15.8, Soy_Milk = 0.4, Breakfast_Milk_Breakfast_Drink = 10.1, Peanuts = 0.053,
  Other_Nuts = 0.024844, Soybeans = 0.1, Mung_Beans = 0.3, Soybean_Milk = 0.2, Tofu = 0.3, Dried_Tofu = 0.8,
  Tofu_Skin = 0.3, Tofu_Strips = 0.1, Fried_Tofu = 0.2, Mung_Bean_Sprouts = 0.4, Wood_Ear_Mushroom = 0.5,
  Mushroom = 0.495, Shiitake_Mushroom = 0.2, Dried_Shiitake = 0.19, Dried_Fish = 1.6)
  )

  df$FA_15_0 <- calc_sparse_nutrient(
c(Cuttlefish_Balls = 0.2, Century_Egg = 0.09, Chicken_Egg = 8.004, Beef = 0.9, Mutton = 0.3,
  Rabbit_Meat = 0.45, Chicken = 0.063, Duck = 0.068, Chicken_Gizzard = 0.1, Chicken_Wings = 0.207,
  Chicken_Feet = 0.3, Grass_Carp = 0.116, Silver_Carp = 0.549, Crucian_Carp = 0.378, Perch = 0.348,
  Yellow_Croaker = 0.192, Sardine = 0.201, Black_Carp = 0.756, Spanish_Mackerel = 0.468, Pomfret = 0.49,
  Hairtail = 0.38, Mandarin_Fish = 0.549, Bream = 0.413, Horse_Mackerel = 0.49, Rice_Eel = 0.871,
  Squid = 0.226333, Crab = 0.8, Sea_Shrimp = 0.354, Clam = 0.273, Oyster = 0.7, Razor_Clam = 0.684,
  Mussel = 0.392, Jellyfish = 0.9, Fresh_Milk_Boxed_Milk = 1.1, Milk_Powder = 1.6, Yogurt = 1.3,
  Breakfast_Milk_Breakfast_Drink = 1, Mushroom = 0.495, Shiitake_Mushroom = 0.7, Dried_Shiitake = 0.665,
  Dried_Scallop = 0.5, Dried_Fish = 0.3)
  )

  df$FA_16_0 <- calc_sparse_nutrient(
c(rice = 32.2, White_Congee = 33.2, Noodles = 38.1, White_Steamed_Bread = 66.8,
  Deep_fried_dough_sticks = 3.1, Fish_balls = 47.5, Cuttlefish_Balls = 39.2, Sweet_Potato = 11.18,
  Salted_Duck_Egg = 30.324, Century_Egg = 21.78, Pork_Floss = 22.8, Ham_Sausage = 24, Chicken_Egg = 8.874,
  Duck_Egg = 23.751, Pork = 22.659, Pork_Chops = 19.665, Beef = 27, Mutton = 26.5, Rabbit_Meat = 24.55,
  Chicken = 15.624, Duck = 14.756, Pork_Tripe = 28.512, Pork_Liver = 34, Pork_Trotters = 13.05,
  Pork_Blood = 23.1, Chicken_Gizzard = 25, Chicken_Wings = 28.083, Chicken_Feet = 10.92, Grass_Carp = 11.716,
  Silver_Carp = 12.688, Crucian_Carp = 10.638, Perch = 13.804, Yellow_Croaker = 18.464, Eel = 21.756,
  Sardine = 12.998, Black_Carp = 15.75, Mackerel = 6.125, Spanish_Mackerel = 17.676, Pomfret = 19.32,
  Hairtail = 22.344, Mandarin_Fish = 13.298, Dike_Fish = 17.728, Bream = 10.856, Horse_Mackerel = 12.18,
  Rice_Eel = 13.869, Squid = 46.721667, Crab = 20.1, Sea_Shrimp = 15.576, Clam = 8.736, Oyster = 22.7,
  Razor_Clam = 15.048, Mussel = 16.611, Jellyfish = 45.5, Fresh_Milk_Boxed_Milk = 30.2, Milk_Powder = 28.2,
  Yogurt = 33.5, Soy_Milk = 10.3, Breakfast_Milk_Breakfast_Drink = 31, Peanuts = 6.572,
  Other_Nuts = 6.832031, Soybeans = 10.8, Mung_Beans = 23.6, Soybean_Milk = 40.3, Tofu = 25.2,
  Dried_Tofu = 14.6, Tofu_Skin = 21.1, Tofu_Strips = 11.7, Fried_Tofu = 16.5, Soybean_Sprouts = 13.6,
  Mung_Bean_Sprouts = 19.1, Wood_Ear_Mushroom = 17.6, Mushroom = 14.157, Shiitake_Mushroom = 11.2,
  Dried_Shiitake = 10.64, Dried_Scallop = 18.8, Dried_Fish = 16.4)
  )

  df$FA_17_0 <- calc_sparse_nutrient(
c(Century_Egg = 0.36, Pork_Floss = 0.2, Ham_Sausage = 0.3, Chicken_Egg = 14.355, Pork = 0.455, Beef = 0.6,
  Mutton = 0.8, Rabbit_Meat = 0.25, Chicken = 0.063, Duck = 0.136, Grass_Carp = 1.682, Silver_Carp = 0.061,
  Crucian_Carp = 0.108, Perch = 0.406, Yellow_Croaker = 0.192, Sardine = 0.536, Black_Carp = 0.315,
  Spanish_Mackerel = 0.324, Pomfret = 0.07, Hairtail = 0.532, Dike_Fish = 1.344, Bream = 0.059,
  Rice_Eel = 0.268, Squid = 0.582, Sea_Shrimp = 0.472, Oyster = 1.6, Razor_Clam = 0.171, Mussel = 0.196,
  Jellyfish = 1.4, Fresh_Milk_Boxed_Milk = 0.7, Milk_Powder = 0.1, Yogurt = 0.2,
  Breakfast_Milk_Breakfast_Drink = 0.6, Wood_Ear_Mushroom = 0.4, Dried_Scallop = 2.2, Dried_Fish = 1.1)
  )

  df$FA_18_0 <- calc_sparse_nutrient(
c(rice = 2.2, White_Congee = 3, Noodles = 4.766667, White_Steamed_Bread = 6.4, Deep_fried_dough_sticks = 1,
  Fish_balls = 7.8, Cuttlefish_Balls = 4.1, Sweet_Potato = 3.87, Salted_Duck_Egg = 0.672, Century_Egg = 4.86,
  Pork_Floss = 10.5, Ham_Sausage = 13.2, Chicken_Egg = 15.747, Duck_Egg = 6.09, Pork = 11.466,
  Pork_Chops = 11.385, Beef = 19.5, Mutton = 24.9, Rabbit_Meat = 13.8, Chicken = 4.536, Duck = 4.216,
  Pork_Tripe = 18.816, Pork_Liver = 22.4, Pork_Trotters = 5.46, Pork_Blood = 23.3, Chicken_Gizzard = 13.6,
  Chicken_Wings = 6.693, Chicken_Feet = 3.36, Grass_Carp = 0.116, Silver_Carp = 2.928, Crucian_Carp = 2.592,
  Perch = 3.48, Yellow_Croaker = 3.712, Eel = 3.78, Sardine = 4.02, Black_Carp = 4.914, Mackerel = 0.735,
  Spanish_Mackerel = 6.372, Pomfret = 4.69, Hairtail = 6.004, Mandarin_Fish = 2.928, Dike_Fish = 4.544,
  Bream = 2.183, Horse_Mackerel = 2.73, Rice_Eel = 3.752, Squid = 14.065, Crab = 9.8, Sea_Shrimp = 4.425,
  Clam = 1.053, Oyster = 4.6, Razor_Clam = 4.788, Mussel = 2.842, Jellyfish = 15.9,
  Fresh_Milk_Boxed_Milk = 11.3, Milk_Powder = 10.8, Yogurt = 9.3, Breakfast_Milk_Breakfast_Drink = 12.4,
  Peanuts = 1.961, Other_Nuts = 1.739063, Soybeans = 3.4, Mung_Beans = 5.5, Soybean_Milk = 10.4, Tofu = 7.8,
  Dried_Tofu = 3.6, Tofu_Skin = 4.7, Tofu_Strips = 2.4, Fried_Tofu = 1.9, Soybean_Sprouts = 5,
  Mung_Bean_Sprouts = 7.3, Wood_Ear_Mushroom = 4.6, Mushroom = 3.465, Shiitake_Mushroom = 1,
  Dried_Shiitake = 0.95, Dried_Scallop = 7.6, Dried_Fish = 6.5)
  )

  df$FA_19_0 <- calc_sparse_nutrient(
c(Deep_fried_dough_sticks = 0.3, Chicken_Egg = 0.522, Chicken = 0.252, Pork_Trotters = 0.03,
  Grass_Carp = 1.16, Silver_Carp = 0.122, Crucian_Carp = 0.054, Yellow_Croaker = 0.032, Eel = 2.352,
  Pomfret = 0.07, Bream = 0.118, Rice_Eel = 0.067, Oyster = 0.4, Razor_Clam = 0.342, Mussel = 0.196,
  Yogurt = 0.1, Tofu = 0.5, Dried_Tofu = 0.6, Tofu_Strips = 0.2)
  )

  df$FA_20_0 <- calc_sparse_nutrient(
c(Century_Egg = 0.54, Ham_Sausage = 0.1, Duck_Egg = 0.174, Pork = 0.273, Mutton = 0.6, Chicken = 0.504,
  Duck = 0.952, Pork_Tripe = 0.384, Pork_Trotters = 0.09, Pork_Blood = 0.9, Silver_Carp = 0.793,
  Crucian_Carp = 0.324, Yellow_Croaker = 0.256, Sardine = 0.402, Black_Carp = 1.512,
  Spanish_Mackerel = 0.504, Pomfret = 0.21, Hairtail = 0.228, Mandarin_Fish = 0.244, Bream = 0.413,
  Horse_Mackerel = 0.98, Rice_Eel = 0.134, Squid = 0.064667, Crab = 0.5, Sea_Shrimp = 0.177, Oyster = 1.8,
  Razor_Clam = 0.171, Mussel = 0.833, Jellyfish = 0.2, Fresh_Milk_Boxed_Milk = 0.2, Milk_Powder = 0.3,
  Soy_Milk = 0.3, Breakfast_Milk_Breakfast_Drink = 0.2, Peanuts = 0.53, Other_Nuts = 0.124219,
  Soybeans = 1.4, Mung_Beans = 1.3, Tofu = 0.1, Dried_Tofu = 0.5, Tofu_Strips = 1.4, Soybean_Sprouts = 0.5,
  Mung_Bean_Sprouts = 0.9, Dried_Scallop = 1.3, Dried_Fish = 0.1)
  )

  df$FA_22_0 <- calc_sparse_nutrient(
c(Duck_Egg = 0.087, Chicken = 0.189, Pork_Blood = 1.3, Crucian_Carp = 0.216, Yellow_Croaker = 0.064,
  Sardine = 0.536, Spanish_Mackerel = 0.108, Bream = 0.118, Horse_Mackerel = 0.35, Rice_Eel = 0.067,
  Squid = 0.064667, Crab = 0.3, Fresh_Milk_Boxed_Milk = 0.1, Milk_Powder = 0.1, Soy_Milk = 0.6,
  Breakfast_Milk_Breakfast_Drink = 0.1, Peanuts = 1.378, Soybeans = 0.3, Mung_Beans = 1.1, Dried_Tofu = 0.7,
  Soybean_Sprouts = 0.8, Mung_Bean_Sprouts = 2.7, Mushroom = 4.653)
  )

  df$FA_24_0 <- calc_sparse_nutrient(
c(Squid = 0.064667)
  )

  df$MUFA_total_pct <- calc_sparse_nutrient(
c(rice = 20.6, White_Congee = 21.7, Noodles = 19.966667, White_Steamed_Bread = 21.3,
  Deep_fried_dough_sticks = 63.8, Fish_balls = 32.4, Cuttlefish_Balls = 43.7, Sweet_Potato = 25.198,
  Salted_Duck_Egg = 52.584, Century_Egg = 50.76, Pork_Floss = 55.4, Ham_Sausage = 49, Chicken_Egg = 23.49,
  Duck_Egg = 44.979, Pork = 45.409, Pork_Chops = 33.3615, Beef = 44.3, Mutton = 32.5, Rabbit_Meat = 21.75,
  Chicken = 26.019, Duck = 34, Pork_Tripe = 37.824, Pork_Liver = 37.9, Pork_Trotters = 32.43,
  Pork_Blood = 29.2, Chicken_Gizzard = 39.2, Chicken_Wings = 32.361, Chicken_Feet = 32.4,
  Grass_Carp = 22.852, Silver_Carp = 23.79, Crucian_Carp = 23.274, Perch = 19.662, Yellow_Croaker = 30.112,
  Eel = 34.944, Sardine = 16.75, Black_Carp = 21.609, Mackerel = 22.197, Spanish_Mackerel = 23.292,
  Pomfret = 30.87, Hairtail = 28.272, Mandarin_Fish = 24.095, Dike_Fish = 16.704, Bream = 26.491,
  Horse_Mackerel = 30.66, Rice_Eel = 29.748, Squid = 14.647, Crab = 27.4, Sea_Shrimp = 15.694, Clam = 7.566,
  Oyster = 21.9, Razor_Clam = 10.545, Mussel = 13.328, Jellyfish = 27.4, Fresh_Milk_Boxed_Milk = 28.5,
  Milk_Powder = 30.8, Yogurt = 26.1, Soy_Milk = 22.8, Breakfast_Milk_Breakfast_Drink = 26.9,
  Peanuts = 20.458, Other_Nuts = 32.880703, Soybeans = 23.4, Mung_Beans = 12, Soybean_Milk = 36.6,
  Tofu = 32.3, Dried_Tofu = 26.2, Tofu_Skin = 30.6, Tofu_Strips = 21.3, Fried_Tofu = 18.1,
  Soybean_Sprouts = 28.7, Mung_Bean_Sprouts = 15.6, Wood_Ear_Mushroom = 32.1, Mushroom = 3.861,
  Shiitake_Mushroom = 12.1, Dried_Shiitake = 11.495, Dried_Scallop = 56.9, Dried_Fish = 31.4)
  )

  df$FA_14_1 <- calc_sparse_nutrient(
c(Beef = 0.4, Mutton = 0.3, Grass_Carp = 0.116, Silver_Carp = 0.427, Sardine = 0.402, Black_Carp = 0.126,
  Spanish_Mackerel = 0.036, Pomfret = 0.21, Hairtail = 0.152, Dike_Fish = 0.576, Sea_Shrimp = 0.059,
  Fresh_Milk_Boxed_Milk = 0.8, Milk_Powder = 0.2, Yogurt = 0.3, Breakfast_Milk_Breakfast_Drink = 0.8)
  )

  df$FA_15_1 <- calc_sparse_nutrient(
c(Rabbit_Meat = 0.05, Perch = 0.116, Yellow_Croaker = 0.032, Sardine = 0.067, Black_Carp = 0.252,
  Spanish_Mackerel = 0.036, Pomfret = 0.07, Mandarin_Fish = 0.549, Rice_Eel = 0.067, Oyster = 0.1,
  Razor_Clam = 0.057, Yogurt = 0.1)
  )

  df$FA_16_1 <- calc_sparse_nutrient(
c(rice = 0.5, Noodles = 0.533333, White_Steamed_Bread = 0.8, Deep_fried_dough_sticks = 0.3,
  Century_Egg = 3.15, Pork_Floss = 2.2, Ham_Sausage = 2.8, Chicken_Egg = 3.654, Duck_Egg = 3.132,
  Pork = 3.64, Pork_Chops = 1.9665, Beef = 4.7, Mutton = 2.1, Rabbit_Meat = 2, Chicken = 2.961, Duck = 3.604,
  Pork_Tripe = 1.344, Pork_Liver = 4.8, Pork_Trotters = 2.52, Pork_Blood = 3.5, Chicken_Gizzard = 3.7,
  Chicken_Wings = 5.244, Chicken_Feet = 9.24, Grass_Carp = 3.828, Silver_Carp = 7.442, Crucian_Carp = 4.752,
  Perch = 7.076, Yellow_Croaker = 12.16, Eel = 5.796, Sardine = 6.7, Black_Carp = 5.166, Mackerel = 2.058,
  Spanish_Mackerel = 5.94, Pomfret = 5.67, Hairtail = 6.156, Mandarin_Fish = 7.015, Dike_Fish = 3.2,
  Bream = 4.956, Horse_Mackerel = 9.24, Rice_Eel = 12.462, Squid = 0.226333, Crab = 9.8, Sea_Shrimp = 2.832,
  Clam = 0.546, Oyster = 6.2, Razor_Clam = 4.959, Mussel = 8.624, Jellyfish = 7.2,
  Fresh_Milk_Boxed_Milk = 1.8, Milk_Powder = 3.4, Yogurt = 1.5, Breakfast_Milk_Breakfast_Drink = 1.7,
  Peanuts = 0.053, Other_Nuts = 0.347812, Soybeans = 0.2, Tofu = 0.5, Dried_Tofu = 0.4, Tofu_Skin = 2,
  Tofu_Strips = 0.1, Soybean_Sprouts = 0.8, Mung_Bean_Sprouts = 0.9, Wood_Ear_Mushroom = 0.7,
  Shiitake_Mushroom = 3, Dried_Shiitake = 2.85, Dried_Scallop = 3.2, Dried_Fish = 6.1)
  )

  df$FA_17_1 <- calc_sparse_nutrient(
c(Century_Egg = 0.27, Pork_Floss = 0.2, Chicken_Egg = 4.35, Beef = 0.3, Mutton = 0.3, Rabbit_Meat = 0.1,
  Grass_Carp = 0.174, Silver_Carp = 0.244, Crucian_Carp = 0.108, Yellow_Croaker = 0.192, Sardine = 0.67,
  Black_Carp = 0.378, Spanish_Mackerel = 0.288, Pomfret = 0.56, Hairtail = 0.304, Bream = 0.059,
  Horse_Mackerel = 0.84, Rice_Eel = 0.469, Sea_Shrimp = 0.059, Oyster = 1.7, Mussel = 0.049,
  Jellyfish = 1.05, Fresh_Milk_Boxed_Milk = 0.2, Yogurt = 0.1, Breakfast_Milk_Breakfast_Drink = 0.2,
  Dried_Scallop = 2.5, Dried_Fish = 1.3)
  )

  df$FA_18_1 <- calc_sparse_nutrient(
c(rice = 20.1, White_Congee = 21.7, Noodles = 19.433333, White_Steamed_Bread = 20.5,
  Deep_fried_dough_sticks = 13.6, Fish_balls = 32.4, Cuttlefish_Balls = 43.7, Sweet_Potato = 25.198,
  Salted_Duck_Egg = 52.584, Century_Egg = 46.17, Pork_Floss = 53, Ham_Sausage = 46.1, Chicken_Egg = 15.486,
  Duck_Egg = 41.586, Pork = 41.678, Pork_Chops = 31.395, Beef = 38.9, Mutton = 29.7, Rabbit_Meat = 19.6,
  Chicken = 22.995, Duck = 30.396, Pork_Tripe = 36.288, Pork_Liver = 33.1, Pork_Trotters = 29.79,
  Pork_Blood = 25.5, Chicken_Gizzard = 35.5, Chicken_Wings = 27.117, Chicken_Feet = 23.16,
  Grass_Carp = 18.502, Silver_Carp = 15.372, Crucian_Carp = 16.308, Perch = 12.47, Yellow_Croaker = 17.632,
  Eel = 28.308, Sardine = 7.705, Black_Carp = 15.687, Mackerel = 5.243, Spanish_Mackerel = 16.776,
  Pomfret = 23.31, Hairtail = 20.976, Mandarin_Fish = 14.579, Dike_Fish = 12.928, Bream = 21.063,
  Horse_Mackerel = 20.37, Rice_Eel = 16.281, Squid = 13.871, Crab = 15.8, Sea_Shrimp = 12.272, Clam = 7.02,
  Oyster = 10.8, Razor_Clam = 3.99, Mussel = 3.234, Jellyfish = 18.45, Fresh_Milk_Boxed_Milk = 25.6,
  Milk_Powder = 27.2, Yogurt = 24.1, Soy_Milk = 22.8, Breakfast_Milk_Breakfast_Drink = 24.1,
  Peanuts = 20.352, Other_Nuts = 32.532891, Soybeans = 23.2, Mung_Beans = 12, Soybean_Milk = 36.6,
  Tofu = 29.6, Dried_Tofu = 25.6, Tofu_Skin = 28.6, Tofu_Strips = 21.2, Fried_Tofu = 18.1,
  Soybean_Sprouts = 27.9, Mung_Bean_Sprouts = 14.2, Wood_Ear_Mushroom = 30.7, Mushroom = 3.861,
  Shiitake_Mushroom = 9.1, Dried_Shiitake = 8.645, Dried_Scallop = 38.6, Dried_Fish = 18.2)
  )

  df$FA_20_1 <- calc_sparse_nutrient(
c(Ham_Sausage = 0.1, Pork = 0.091, Pork_Tripe = 0.192, Pork_Trotters = 0.06, Grass_Carp = 0.116,
  Crucian_Carp = 0.918, Yellow_Croaker = 0.096, Eel = 0.252, Mackerel = 5.635, Pomfret = 0.42,
  Hairtail = 0.228, Mandarin_Fish = 0.244, Bream = 0.177, Rice_Eel = 0.201, Squid = 0.388,
  Sea_Shrimp = 0.472, Oyster = 3.1, Razor_Clam = 1.539, Mussel = 1.078, Jellyfish = 0.7,
  Fresh_Milk_Boxed_Milk = 0.1, Breakfast_Milk_Breakfast_Drink = 0.1, Peanuts = 0.053,
  Wood_Ear_Mushroom = 0.7, Dried_Scallop = 2.1, Dried_Fish = 5.8)
  )

  df$FA_22_1 <- calc_sparse_nutrient(
c(Deep_fried_dough_sticks = 49.9, Century_Egg = 1.17, Duck_Egg = 0.261, Mutton = 0.1, Chicken = 0.063,
  Pork_Trotters = 0.06, Pork_Blood = 0.2, Grass_Carp = 0.116, Silver_Carp = 0.305, Crucian_Carp = 1.188,
  Eel = 0.588, Sardine = 1.206, Mackerel = 9.261, Spanish_Mackerel = 0.216, Pomfret = 0.63, Hairtail = 0.456,
  Mandarin_Fish = 1.708, Bream = 0.236, Horse_Mackerel = 0.21, Rice_Eel = 0.268, Squid = 0.097, Crab = 1.8,
  Mussel = 0.343, Tofu = 2.2, Dried_Tofu = 1.2, Mung_Bean_Sprouts = 0.5, Dried_Scallop = 10.5)
  )

  df$FA_24_1 <- calc_sparse_nutrient(
c(Squid = 0.064667)
  )

  df$PUFA_total_pct <- calc_sparse_nutrient(
c(rice = 42.6, White_Congee = 38.9, Noodles = 34.733333, White_Steamed_Bread = 3.3,
  Deep_fried_dough_sticks = 19, Fish_balls = 8.2, Cuttlefish_Balls = 10.6, Sweet_Potato = 26.574,
  Century_Egg = 11.7, Pork_Floss = 9.6, Ham_Sausage = 10.4, Chicken_Egg = 6.351, Duck_Egg = 8.874,
  Pork = 7.189, Pork_Chops = 3.0705, Beef = 3.7, Mutton = 10.7, Rabbit_Meat = 36.9, Chicken = 15.687,
  Duck = 13.26, Pork_Tripe = 8.256, Pork_Liver = 3.2, Pork_Trotters = 6.3, Pork_Blood = 17.7,
  Chicken_Gizzard = 21.7, Chicken_Wings = 0.828, Chicken_Feet = 13.14, Grass_Carp = 13.688,
  Silver_Carp = 11.895, Crucian_Carp = 13.662, Perch = 15.196, Yellow_Croaker = 6.112, Eel = 15.288,
  Sardine = 21.038, Black_Carp = 6.93, Mackerel = 15.484, Spanish_Mackerel = 14.112, Pomfret = 6.72,
  Hairtail = 9.728, Mandarin_Fish = 15.25, Dike_Fish = 19.008, Bream = 11.151, Horse_Mackerel = 17.22,
  Rice_Eel = 11.055, Squid = 18.947333, Crab = 31.7, Sea_Shrimp = 17.818, Clam = 21.138, Oyster = 34.6,
  Razor_Clam = 19.152, Mussel = 9.31, Jellyfish = 1.15, Fresh_Milk_Boxed_Milk = 4.1, Milk_Powder = 5.3,
  Yogurt = 2.5, Soy_Milk = 61.7, Breakfast_Milk_Breakfast_Drink = 3.7, Peanuts = 20.458,
  Other_Nuts = 33.029766, Soybeans = 61.1, Mung_Beans = 55, Soybean_Milk = 10.2, Tofu = 32.3,
  Dried_Tofu = 53.6, Tofu_Skin = 43.2, Tofu_Strips = 62.5, Fried_Tofu = 63.3, Soybean_Sprouts = 51.1,
  Mung_Bean_Sprouts = 48.6, Wood_Ear_Mushroom = 44.8, Mushroom = 70.191, Shiitake_Mushroom = 74.5,
  Dried_Shiitake = 70.775, Dried_Scallop = 8.5, Dried_Fish = 35.7)
  )

  df$FA_16_2 <- calc_sparse_nutrient(
c(Pork = 0.182, Beef = 0.2, Mutton = 1.2, Chicken = 0.63, Pork_Trotters = 0.15, Yellow_Croaker = 0.032,
  Razor_Clam = 0.627, Milk_Powder = 0.6)
  )

  df$FA_18_2 <- calc_sparse_nutrient(
c(rice = 39.4, White_Congee = 38.9, Noodles = 33.233333, White_Steamed_Bread = 3.3,
  Deep_fried_dough_sticks = 12.5, Fish_balls = 6.8, Cuttlefish_Balls = 10.6, Sweet_Potato = 26.574,
  Century_Egg = 9.09, Pork_Floss = 7.5, Ham_Sausage = 9.6, Chicken_Egg = 4.611, Duck_Egg = 7.221,
  Pork = 5.187, Pork_Chops = 1.587, Beef = 2.9, Mutton = 7.2, Rabbit_Meat = 25.65, Chicken = 13.545,
  Duck = 12.648, Pork_Tripe = 7.392, Pork_Liver = 2.8, Pork_Trotters = 5.76, Pork_Blood = 17.7,
  Chicken_Gizzard = 20.5, Chicken_Wings = 0.828, Chicken_Feet = 12.54, Grass_Carp = 9.86,
  Silver_Carp = 5.551, Crucian_Carp = 8.37, Perch = 1.16, Yellow_Croaker = 1.216, Eel = 1.596,
  Sardine = 1.407, Black_Carp = 3.717, Mackerel = 0.735, Spanish_Mackerel = 1.08, Pomfret = 0.63,
  Hairtail = 1.064, Mandarin_Fish = 4.636, Dike_Fish = 0.256, Bream = 5.9, Horse_Mackerel = 4.41,
  Rice_Eel = 5.226, Squid = 0.064667, Crab = 1.8, Sea_Shrimp = 5.31, Clam = 17.667, Oyster = 2.1,
  Razor_Clam = 0.741, Mussel = 1.029, Jellyfish = 0.45, Fresh_Milk_Boxed_Milk = 3.6, Milk_Powder = 3.6,
  Yogurt = 1.9, Soy_Milk = 52.1, Breakfast_Milk_Breakfast_Drink = 3.3, Peanuts = 19.981,
  Other_Nuts = 28.694531, Soybeans = 52.9, Mung_Beans = 40.7, Soybean_Milk = 10.2, Tofu = 29.2,
  Dried_Tofu = 46.3, Tofu_Skin = 39.4, Tofu_Strips = 54, Fried_Tofu = 56.5, Soybean_Sprouts = 46.1,
  Mung_Bean_Sprouts = 17.9, Wood_Ear_Mushroom = 41, Mushroom = 69.003, Shiitake_Mushroom = 60.2,
  Dried_Shiitake = 57.19, Dried_Scallop = 6.3, Dried_Fish = 0.7)
  )

  df$FA_18_3 <- calc_sparse_nutrient(
c(rice = 3.2, Noodles = 2.25, Deep_fried_dough_sticks = 6.5, Fish_balls = 1.4, Century_Egg = 1.17,
  Pork_Floss = 1.8, Ham_Sausage = 0.7, Duck_Egg = 0.522, Pork = 1.547, Pork_Chops = 1.4835, Beef = 0.5,
  Mutton = 1.5, Rabbit_Meat = 6.35, Chicken = 1.323, Duck = 0.612, Pork_Tripe = 0.384, Pork_Liver = 0.4,
  Pork_Trotters = 0.27, Chicken_Gizzard = 1.2, Chicken_Feet = 0.6, Grass_Carp = 2.726, Silver_Carp = 4.453,
  Crucian_Carp = 2.754, Perch = 1.798, Yellow_Croaker = 1.28, Eel = 3.444, Sardine = 6.365,
  Black_Carp = 1.197, Mackerel = 0.931, Spanish_Mackerel = 1.584, Pomfret = 3.08, Hairtail = 1.368,
  Mandarin_Fish = 10.614, Dike_Fish = 2.112, Bream = 2.36, Horse_Mackerel = 2.45, Rice_Eel = 3.283,
  Crab = 2.1, Sea_Shrimp = 2.478, Clam = 3.471, Oyster = 7.8, Razor_Clam = 2.223, Mussel = 1.47,
  Fresh_Milk_Boxed_Milk = 0.4, Milk_Powder = 0.9, Yogurt = 0.6, Soy_Milk = 9.6,
  Breakfast_Milk_Breakfast_Drink = 0.3, Peanuts = 0.477, Other_Nuts = 4.335234, Soybeans = 8.2,
  Mung_Beans = 14.3, Tofu = 3.1, Dried_Tofu = 7.2, Tofu_Skin = 3.8, Tofu_Strips = 8.5, Fried_Tofu = 6.8,
  Soybean_Sprouts = 5, Mung_Bean_Sprouts = 23.7, Wood_Ear_Mushroom = 3.8, Mushroom = 1.188,
  Shiitake_Mushroom = 14.3, Dried_Shiitake = 13.585, Dried_Scallop = 0.9, Dried_Fish = 0.2)
  )

  df$FA_18_4 <- calc_sparse_nutrient(
c(Mackerel = 3.43)
  )

  df$FA_20_2 <- calc_sparse_nutrient(
c(Chicken_Egg = 1.305, Pork = 0.182, Pork_Trotters = 0.06, Grass_Carp = 0.174, Silver_Carp = 0.244,
  Crucian_Carp = 0.054, Yellow_Croaker = 0.032, Black_Carp = 0.063, Pomfret = 0.07, Bream = 0.059,
  Rice_Eel = 0.067, Squid = 0.064667, Sea_Shrimp = 2.301, Oyster = 1.7, Razor_Clam = 0.684, Mussel = 0.098,
  Dried_Fish = 0.1)
  )

  df$FA_20_3 <- calc_sparse_nutrient(
c(Century_Egg = 0.09, Grass_Carp = 0.058, Crucian_Carp = 0.108, Perch = 0.464, Yellow_Croaker = 0.032,
  Black_Carp = 0.315, Spanish_Mackerel = 0.216, Bream = 0.059, Sea_Shrimp = 0.118, Oyster = 0.2,
  Razor_Clam = 1.767, Fresh_Milk_Boxed_Milk = 0.1, Breakfast_Milk_Breakfast_Drink = 0.1, Dried_Scallop = 1.3)
  )

  df$FA_20_4 <- calc_sparse_nutrient(
c(Century_Egg = 1.35, Pork_Floss = 0.3, Ham_Sausage = 0.1, Chicken_Egg = 0.174, Duck_Egg = 1.131,
  Pork = 0.091, Beef = 0.1, Mutton = 0.4, Rabbit_Meat = 4.9, Chicken = 0.189, Pork_Tripe = 0.48,
  Pork_Trotters = 0.06, Grass_Carp = 0.348, Crucian_Carp = 0.594, Perch = 1.798, Yellow_Croaker = 0.576,
  Eel = 0.924, Sardine = 1.273, Black_Carp = 0.63, Mackerel = 0.735, Spanish_Mackerel = 0.972,
  Pomfret = 0.35, Hairtail = 0.608, Dike_Fish = 2.624, Bream = 1.357, Horse_Mackerel = 1.4, Rice_Eel = 1.005,
  Squid = 2.780667, Crab = 4.2, Oyster = 1.1, Razor_Clam = 0.228, Mussel = 0.196, Milk_Powder = 0.2,
  Dried_Fish = 0.2)
  )

  df$FA_20_5 <- calc_sparse_nutrient(
c(Mutton = 0.4, Grass_Carp = 0.116, Silver_Carp = 0.305, Crucian_Carp = 0.864, Perch = 3.132,
  Yellow_Croaker = 0.864, Eel = 2.184, Sardine = 4.489, Mackerel = 3.528, Spanish_Mackerel = 1.836,
  Pomfret = 0.91, Hairtail = 1.444, Dike_Fish = 3.328, Bream = 0.649, Horse_Mackerel = 2.87,
  Rice_Eel = 0.201, Squid = 3.427333, Crab = 12.2, Sea_Shrimp = 3.894, Oyster = 10.4, Razor_Clam = 5.814,
  Mussel = 3.675, Dried_Fish = 9.2)
  )

  df$FA_22_3 <- calc_sparse_nutrient(
c(Silver_Carp = 0.732, Crucian_Carp = 0.054, Perch = 0.522, Yellow_Croaker = 0.032, Spanish_Mackerel = 0.612,
  Pomfret = 0.07, Rice_Eel = 0.335, Oyster = 1.7, Razor_Clam = 1.026, Mussel = 0.098)
  )

  df$FA_22_4 <- calc_sparse_nutrient(
c(Chicken_Egg = 0.174, Silver_Carp = 0.61, Crucian_Carp = 0.054, Perch = 3.422, Yellow_Croaker = 0.224,
  Black_Carp = 0.189, Pomfret = 0.14, Hairtail = 0.456, Rice_Eel = 0.067, Sea_Shrimp = 1.298, Oyster = 4.3,
  Razor_Clam = 2.28, Mussel = 0.049, Mung_Bean_Sprouts = 7, Dried_Fish = 0.5)
  )

  df$FA_22_5 <- calc_sparse_nutrient(
c(Grass_Carp = 0.058, Crucian_Carp = 0.216, Perch = 0.522, Yellow_Croaker = 0.192, Eel = 1.932,
  Sardine = 0.871, Black_Carp = 0.126, Mackerel = 0.539, Spanish_Mackerel = 0.216, Pomfret = 0.91,
  Hairtail = 0.76, Dike_Fish = 1.792, Bream = 0.059, Horse_Mackerel = 0.7, Rice_Eel = 0.335,
  Sea_Shrimp = 0.059, Oyster = 1.5, Razor_Clam = 1.083, Mussel = 0.245, Dried_Fish = 2.1)
  )

  df$FA_22_6 <- calc_sparse_nutrient(
c(Grass_Carp = 0.348, Crucian_Carp = 0.594, Perch = 2.378, Yellow_Croaker = 1.632, Eel = 5.208,
  Sardine = 6.633, Black_Carp = 0.693, Mackerel = 5.586, Spanish_Mackerel = 7.596, Pomfret = 0.56,
  Hairtail = 4.028, Dike_Fish = 8.896, Bream = 0.708, Horse_Mackerel = 5.39, Rice_Eel = 0.536, Squid = 12.61,
  Crab = 11.4, Sea_Shrimp = 2.36, Oyster = 3.8, Razor_Clam = 2.679, Mussel = 2.45, Jellyfish = 0.7,
  Dried_Fish = 22.7)
  )

  df$fatty_acid_unknown_pct <- calc_sparse_nutrient(
c(Deep_fried_dough_sticks = 1.5, Salted_Duck_Egg = 0.084, Pork_Floss = 0.5, Ham_Sausage = 0.7,
  Chicken_Egg = 0.696, Duck_Egg = 2.784, Pork = 1.638, Pork_Chops = 0.2415, Beef = 0.3, Rabbit_Meat = 0.5,
  Duck = 0.204, Pork_Tripe = 0.96, Pork_Liver = 0.2, Pork_Trotters = 1.62, Pork_Blood = 3.7,
  Chicken_Wings = 0.138, Grass_Carp = 5.8, Silver_Carp = 6.039, Crucian_Carp = 1.404, Perch = 3.422,
  Yellow_Croaker = 1.92, Eel = 3.108, Sardine = 6.097, Black_Carp = 9.576, Spanish_Mackerel = 7.308,
  Pomfret = 4.13, Hairtail = 3.876, Mandarin_Fish = 3.05, Dike_Fish = 2.176, Bream = 5.9,
  Horse_Mackerel = 3.71, Rice_Eel = 5.092, Crab = 6.8, Sea_Shrimp = 3.481, Oyster = 6.3, Razor_Clam = 2.622,
  Mussel = 0.882, Jellyfish = 2.1, Fresh_Milk_Boxed_Milk = 3, Milk_Powder = 4.4, Yogurt = 0.7,
  Soy_Milk = 0.1, Breakfast_Milk_Breakfast_Drink = 3.5, Peanuts = 0.371, Dried_Scallop = 2.9,
  Dried_Fish = 6.9)
  )

  df$guanine <- calc_sparse_nutrient(
c(Instant_Noodles = 18.6, White_Steamed_Bread = 14.5, Oatmeal = 29.5, Bread = 24.6, Oil_Cake = 14.5,
  Deep_fried_dough_sticks = 9.4, Fried_Cake = 10, Baked_Cake = 13, Sweet_Potato = 6.149, Taro = 6.1,
  Potato = 5.64, Bean_Paste = 38.6, Chicken_Egg = 1.044, Pork = 18.109, Beef = 15.9,
  Mutton = 22.9, Rabbit_Meat = 29.2, Pork_Tripe = 133.344, Pork_Liver = 134, Pork_Blood = 10.5,
  Grass_Carp = 25.143, Silver_Carp = 15.006, Crucian_Carp = 27.135, Yellow_Croaker = 8.448, Sardine = 10.921,
  Mackerel = 103.586, Spanish_Mackerel = 89.604, Squid = 7.275, Oyster = 75.9, Razor_Clam = 14.6775,
  Mussel = 91.875, Jellyfish = 3.7, Fresh_Milk_Boxed_Milk = 0.2, Yogurt = 0.833333, Peanuts = 16.536,
  Other_Nuts = 15.012723, Soybeans = 95.45, Mung_Beans = 88.9, Soybean_Milk = 17.266667, Tofu = 54.4,
  Dried_Tofu = 54.4, Soybean_Sprouts = 18.2, Mung_Bean_Sprouts = 5.3, Green_Beans = 20.928,
  String_Beans = 10.56, Carrot = 6.24, White_Radish = 3.3725, Lotus_Root = 2.376, Bamboo_Shoots = 3.213,
  Cauliflower = 10.168, Chinese_Cabbage = 5.518, Spinach = 2.492, Chinese_Broccoli = 6.37, Rapeseed = 7.008,
  Lettuce = 4.512, Winter_Melon = 0.24, Cucumber = 4.232, Luffa = 4.067, Bitter_Melon = 3.159,
  Pumpkin = 7.055, Tomato = 5.2, Eggplant = 5.7, Wood_Ear_Mushroom = 43.6, Enoki_Mushroom = 15.9,
  Shiitake_Mushroom = 102.766667, Apple = 0.425, Banana = 2.24, Peach = 5.073, Pineapple = 1.564,
  Lychee = 8.906, Watermelon = 1.829, Dragon_Fruit = 3.381, Dried_Shiitake = 97.628333,
  Dried_Seaweed = 170.1, Dried_Scallop = 37.4, Dried_Fish = 68.3)
  )

  df$adenine <- calc_sparse_nutrient(
c(Instant_Noodles = 16.8, White_Steamed_Bread = 12.5, Oatmeal = 28.4, Bread = 22.9, Oil_Cake = 12.4,
  Deep_fried_dough_sticks = 10, Fried_Cake = 10.2, Baked_Cake = 13.4, Sweet_Potato = 8.514, Taro = 6.7,
  Potato = 5.922, Century_Egg = 0.27, Bean_Paste = 33.1, Chicken_Egg = 0.087, Pork = 20.384, Beef = 21.55, Mutton = 24.2, Rabbit_Meat = 46.9, Pork_Tripe = 94.656,
  Pork_Liver = 89.8, Pork_Blood = 19.6, Grass_Carp = 15.196, Silver_Carp = 26.535, Crucian_Carp = 30.159,
  Yellow_Croaker = 63.232, Sardine = 7.638, Mackerel = 12.887, Spanish_Mackerel = 21.6, Squid = 12.416,
  Oyster = 70.25, Razor_Clam = 42.237, Mussel = 59.829, Jellyfish = 3.5, Fresh_Milk_Boxed_Milk = 0.5,
  Yogurt = 0.966667, Peanuts = 19.981, Other_Nuts = 17.152835, Soybeans = 103.95, Mung_Beans = 102.5,
  Soybean_Milk = 12.6, Tofu = 38.7, Dried_Tofu = 38.7, Soybean_Sprouts = 9.6, Mung_Bean_Sprouts = 3.8,
  Green_Beans = 15.456, String_Beans = 9.696, Carrot = 5.472, White_Radish = 3.2775, Lotus_Root = 4.796,
  Bamboo_Shoots = 3.276, Cauliflower = 10.824, Chinese_Cabbage = 3.916, Spinach = 1.246,
  Chinese_Broccoli = 7.448, Rapeseed = 7.488, Lettuce = 4.7, Winter_Melon = 0.24, Cucumber = 4.232,
  Luffa = 4.897, Bitter_Melon = 3.402, Pumpkin = 12.835, Tomato = 8.9, Eggplant = 3.8,
  Wood_Ear_Mushroom = 51.4, Enoki_Mushroom = 36.4, Shiitake_Mushroom = 153.666667, Apple = 0.34,
  Banana = 2.17, Peach = 4.094, Pineapple = 1.768, Lychee = 4.672, Watermelon = 1.298, Dragon_Fruit = 3.933,
  Dried_Shiitake = 145.983333, Dried_Seaweed = 196.8, Dried_Scallop = 124.7, Dried_Fish = 33.7)
  )

  df$hypoxanthine <- calc_sparse_nutrient(
c(Instant_Noodles = 0.2, White_Steamed_Bread = 0.3, Oatmeal = 0.8, Bread = 0.75, Fried_Cake = 0.4,
  Baked_Cake = 0.1, Sweet_Potato = 0.172, Taro = 0.9, Potato = 0.188, Century_Egg = 0.18, Bean_Paste = 2.8,
  Chicken_Egg = 0.087, Pork = 86.45, Beef = 72.7, Mutton = 53.9, Rabbit_Meat = 69.5,
  Pork_Tripe = 10.08, Pork_Liver = 18.7, Pork_Blood = 10, Grass_Carp = 44.66, Silver_Carp = 44.408,
  Crucian_Carp = 34.911, Yellow_Croaker = 33.152, Sardine = 36.515, Mackerel = 29.743,
  Spanish_Mackerel = 127.944, Squid = 190.314, Oyster = 70.4, Razor_Clam = 40.185, Mussel = 44.884,
  Jellyfish = 1.2, Fresh_Milk_Boxed_Milk = 0.05, Yogurt = 0.5, Peanuts = 0.053, Other_Nuts = 1.298973,
  Soybeans = 0.5, Mung_Beans = 0.5, Soybean_Milk = 1.5, Tofu = 0.3, Dried_Tofu = 0.3, Soybean_Sprouts = 0.4,
  Mung_Bean_Sprouts = 0.3, Green_Beans = 0.192, String_Beans = 0.096, Carrot = 1.728, White_Radish = 1.33,
  Lotus_Root = 0.088, Bamboo_Shoots = 0.819, Cauliflower = 2.542, Chinese_Cabbage = 1.958, Spinach = 2.047,
  Chinese_Broccoli = 0.98, Rapeseed = 0.384, Lettuce = 2.538, Winter_Melon = 0.08, Cucumber = 1.564,
  Luffa = 1.66, Bitter_Melon = 1.053, Pumpkin = 0.51, Tomato = 1.9, Eggplant = 1.33, Wood_Ear_Mushroom = 4.3,
  Enoki_Mushroom = 5.4, Shiitake_Mushroom = 5.333333, Apple = 0.34, Banana = 0.28, Peach = 2.314,
  Pineapple = 0.204, Lychee = 0.949, Watermelon = 0.236, Dragon_Fruit = 0.069, Dried_Shiitake = 5.066667,
  Dried_Seaweed = 47.7, Dried_Scallop = 72, Dried_Fish = 69.7)
  )

  df$xanthine <- calc_sparse_nutrient(
c(White_Steamed_Bread = 0.1, Bread = 2, Oil_Cake = 0.1, Deep_fried_dough_sticks = 0.1, Baked_Cake = 0.2,
  Sweet_Potato = 3.526, Taro = 1.8, Potato = 0.47, Bean_Paste = 2.7, Pork = 0.546,
  Beef = 5.85, Mutton = 8.1, Rabbit_Meat = 2.8, Pork_Tripe = 3.84, Pork_Liver = 32.7, Pork_Blood = 0.1,
  Grass_Carp = 1.015, Silver_Carp = 0.244, Crucian_Carp = 0.837, Yellow_Croaker = 0.896, Sardine = 0.134,
  Spanish_Mackerel = 0.684, Squid = 27.063, Oyster = 0.75, Razor_Clam = 0.3705, Mussel = 6.027,
  Jellyfish = 1, Yogurt = 0.666667, Peanuts = 8.745, Other_Nuts = 3.822388, Soybeans = 2.2, Mung_Beans = 3.8,
  Soybean_Milk = 0.883333, Tofu = 0.4, Dried_Tofu = 0.4, Soybean_Sprouts = 0.5, Mung_Bean_Sprouts = 1.7,
  Green_Beans = 1.632, String_Beans = 2.016, Carrot = 2.88, White_Radish = 1.6625, Lotus_Root = 1.716,
  Bamboo_Shoots = 1.134, Cauliflower = 10.086, Chinese_Cabbage = 1.068, Spinach = 1.246,
  Chinese_Broccoli = 3.822, Rapeseed = 1.056, Lettuce = 3.854, Winter_Melon = 0.32, Cucumber = 0.184,
  Luffa = 1.245, Bitter_Melon = 2.187, Pumpkin = 4.675, Tomato = 0.9, Eggplant = 1.9,
  Wood_Ear_Mushroom = 2.8, Enoki_Mushroom = 0.9, Shiitake_Mushroom = 4.433333, Peach = 0.534,
  Pineapple = 4.284, Lychee = 0.219, Watermelon = 0.118, Dragon_Fruit = 1.242, Dried_Shiitake = 4.211667,
  Dried_Seaweed = 0.7, Dried_Scallop = 0.8, Dried_Fish = 6.85)
  )

  df$purine_total <- calc_sparse_nutrient(
c(Instant_Noodles = 36, White_Steamed_Bread = 27, Oatmeal = 59, Bread = 50.5, Oil_Cake = 27,
  Deep_fried_dough_sticks = 19, Fried_Cake = 21, Baked_Cake = 27, Sweet_Potato = 18.49, Taro = 15,
  Potato = 12.22, Century_Egg = 0.9, Bean_Paste = 77, Chicken_Egg = 0.87, Pork = 125.58,
  Beef = 116, Mutton = 109, Rabbit_Meat = 148, Pork_Tripe = 241.92, Pork_Liver = 275, Pork_Blood = 40,
  Grass_Carp = 85.84, Silver_Carp = 86.01, Crucian_Carp = 92.88, Yellow_Croaker = 105.6, Sardine = 54.94,
  Mackerel = 146.02, Spanish_Mackerel = 239.76, Squid = 236.68, Oyster = 217.5, Razor_Clam = 97.47,
  Mussel = 202.86, Jellyfish = 9, Fresh_Milk_Boxed_Milk = 1, Yogurt = 3, Peanuts = 45.05,
  Other_Nuts = 37.265625, Soybeans = 202, Mung_Beans = 196, Soybean_Milk = 32.166667, Tofu = 94,
  Dried_Tofu = 94, Soybean_Sprouts = 29, Mung_Bean_Sprouts = 11, Green_Beans = 38.4, String_Beans = 22.08,
  Carrot = 16.32, White_Radish = 9.5, Lotus_Root = 8.8, Bamboo_Shoots = 8.19, Cauliflower = 33.62,
  Chinese_Cabbage = 12.46, Spinach = 7.12, Chinese_Broccoli = 18.62, Rapeseed = 16.32, Lettuce = 15.04,
  Winter_Melon = 0.8, Cucumber = 10.12, Luffa = 11.62, Bitter_Melon = 9.72, Pumpkin = 24.65, Tomato = 17,
  Eggplant = 12.35, Wood_Ear_Mushroom = 102, Enoki_Mushroom = 59, Shiitake_Mushroom = 266.333333,
  Apple = 0.85, Banana = 4.9, Peach = 12.46, Pineapple = 7.48, Lychee = 14.6, Watermelon = 3.54,
  Dragon_Fruit = 8.97, Dried_Shiitake = 253.016667, Dried_Seaweed = 415, Dried_Scallop = 235,
  Dried_Fish = 178.5)
  )
  return(df)
}
