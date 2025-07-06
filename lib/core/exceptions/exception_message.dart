enum ExceptionMessage {
  /* 의존성 누락 관련 메시지 */
  dependencyNotInjectedException(400, "의존성이 올바르게 주입되지 않았습니다. 다시 시작해 주세요."),
  /* 요청 관련 메시지 */
  badRequest(400, "잘못된 요청입니다. 잠시 후에 다시 요청해 주세요."),
  progressing(400, "요청을 처리중입니다. 잠시 기다려 주세요."),
  noObjectAssigned(400, "인증 정보가 만료되어 처리할 수 없는 요청입니다. 다시 로그인 후 진행해 주세요"),
  invalidType(400, "잘못된 요청이거나 처리할 수 없는 타입입니다. 확인 후 다시 요청해 주세요."),
  cantOpenUri(400, "폼을 열 수 없습니다. 잠시 후 다시 요청해 주세요."),
  /* NULL 관련 메시지 */
  nullPointException(400, "존재하지 않는 값입니다. 확인 후 다시 요청해 주세요."),
  /* 이메일 및 패스워드 관련 메시지 */
  emailDuplicated(400, "이미 존재하는 이메일 입니다."),
  wrongEmailRegExp(400, "잘못된 형식의 이메일입니다"),
  wrongPasswordRegExp(400, "잘못된 형식의 패스워드입니다."),
  wrongEmailOrPassword(400, "이메일이나 패스워드가 잘못되었습니다."),
  wrongInvitationCode(400, "초대코드가 잘못되었습니다."),
  notEqualPasswordAndPasswordCheck(400, "패스워드를 다시 한번 확인해 주세요."),
  /* 닉네임 관련 메시지 */
  wrongNameRegExp(400, "잘못된 형식의 닉네임입니다."),
  /* 나이 관련 메시지 */
  wrongAgeRegExp(400, "올바른 형식의 나이를 입력해 주세요."),
  /* 포인트 관련 메시지 */
  cantUsePoint(400, "사용 가능한 포인트를 초과했습니다."),
  /* 채팅 관련 메시지 */
  needMorePersonality(400, "성격은 최소 20자 이상 입력되어야 합니다."),
  needMoreConversationStyle(400, "말투나 대화 스타일은 최소 20자 이상 입력되어야 합니다."),
  memberNameRequired(400, "내 이름이 입력되어야 합니다."),
  memberPersonalityRequired(400, "내 성격이 입력되어야 합니다."),
  memberConversationStyleRequired(400, "내 말투 및 대화 스타일이 입력되어야 합니다."),
  targetInformationRequired(400, "단절된 대상에 대한 추가 정보(성격 등)가 입력되어야 합니다."),
  targetPositiveIssueRequired(400, "단절된 대상과의 긍정적인 기억이 하나 이상 입력되어야 합니다."),
  targetNegativeIssueRequired(400, "단절된 대상과의 부정적인 기억이 하나 이상 입력되어야 합니다."),
  targetNameRequired(400, "단절된 대상의 이름이 입력되어야 합니다."),
  targetRelationshipRequired(400, "단절된 대상과의 관계가 입력되어야 합니다."),
  targetPersonalityRequired(400, "단절된 대상의 성격이 입력되어야 합니다."),
  targetConversationStyleRequired(400, "단절된 대상의 말투 및 대화 스타일이 입력되어야 합니다.");

  final int statusCode;
  final String description;

  const ExceptionMessage(this.statusCode, this.description);
}
