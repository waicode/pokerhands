module Const

  # ------------------------------------
  # カード役
  # ------------------------------------

  # HD_RYL_STRT_FLSH = 5
  HD_STRT_FLSH = 10
  HD_4_KD = 20
  HD_FL_HUS = 30
  HD_FLSH = 40
  HD_STRT = 50
  HD_3_KD = 60
  HD_2_PR = 70
  HD_1_PR = 80
  HD_HI_CD = 90

  HANDS_NAME = {
      # HD_RYL_STRT_FLSH => 'Royal Straight flush',
      HD_STRT_FLSH => 'Straight flush',
      HD_4_KD => 'Four of a kind',
      HD_FL_HUS => 'Full house',
      HD_FLSH => 'Flush',
      HD_STRT => 'Straight',
      HD_3_KD => 'Three of a kind',
      HD_2_PR => 'Two Pair',
      HD_1_PR => 'One Pair',
      HD_HI_CD => 'High Card'
  }

  # ------------------------------------
  # スート
  # ------------------------------------

  S_SPD = "S"
  S_HRT = "H"
  S_DYA = "D"
  S_CLB = "C"
  # S_NON = "N"

  # ------------------------------------
  # その他
  # ------------------------------------

  SEPARATE_CHAR = " "
  REG_CARD_STYLE = "[#{S_SPD}#{S_HRT}#{S_DYA}#{S_CLB}]([1-9]|1[0-3])"

end