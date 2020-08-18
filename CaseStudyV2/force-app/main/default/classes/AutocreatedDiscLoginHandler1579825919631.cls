// This auto-generated class contains the default logic for login discovery by SMS or email. 
// You can customize the code to ensure it meets your needs. The requestAttributes parameter 
// provides additional information you can use in the discovery logic. Attributes include CommunityUrl, 
// IpAddress, UserAgent, and location information (such as Country and City). 

global class AutocreatedDiscLoginHandler1579825919631 implements Auth.LoginDiscoveryHandler {

global PageReference login(String identifier, String startUrl, Map<String, String> requestAttributes) {
	if (identifier != null && isValidEmail(identifier)) {
		// Search for user by email 
		List<User> users = [SELECT Id FROM User WHERE Email = :identifier AND IsActive = TRUE];
		if (!users.isEmpty() && users.size() == 1) {
			// User must have verified email before using this verification method. We cannot send messages to unverified emails. 
			// You can check if the user has email verified bit on and add the password verification method as fallback.
			List<TwoFactorMethodsInfo> verifiedInfo = [SELECT HasUserVerifiedEmailAddress FROM TwoFactorMethodsInfo WHERE UserId = :users[0].Id];
			if (!verifiedInfo.isEmpty() && verifiedInfo[0].HasUserVerifiedEmailAddress == true) {
				// Use email verification method if the user's email is verified.
				return discoveryResult(users[0], Auth.VerificationMethod.EMAIL, startUrl, requestAttributes);
			} else {
				// Use password verification method as fallback if the user's email is unverified.
				return discoveryResult(users[0], Auth.VerificationMethod.PASSWORD, startUrl, requestAttributes);
			}
		} else {
			throw new Auth.LoginDiscoveryException('No unique user found. User count=' + users.size());
		}
	}
	if (identifier != null) {
		String formattedSms = getFormattedSms(identifier);
		if (formattedSms != null) {
			// Search for user by SMS 
			List<User> users = [SELECT Id FROM User WHERE MobilePhone = :formattedSms AND IsActive = TRUE];
			if (!users.isEmpty() && users.size() == 1) {
				// User must have verified SMS before using this verification method. We cannot send messages to unverified mobile numbers. 
				// You can check if the user has mobile verified bit on or add the password verification method as fallback.
				List<TwoFactorMethodsInfo> verifiedInfo = [SELECT HasUserVerifiedMobileNumber FROM TwoFactorMethodsInfo WHERE UserId = :users[0].Id];
				if (!verifiedInfo.isEmpty() && verifiedInfo[0].HasUserVerifiedMobileNumber == true) {
					// Use SMS verification method if the user's mobile number is verified.
					return discoveryResult(users[0], Auth.VerificationMethod.SMS, startUrl, requestAttributes);
				} else {
					// Use password verification method as fallback if the user's mobile number is unverified.
					return discoveryResult(users[0], Auth.VerificationMethod.PASSWORD, startUrl, requestAttributes);
				}
			} else {
				throw new Auth.LoginDiscoveryException('No unique user found. User count=' + users.size());
			}
		}
	}
	if (identifier != null) {
		// You can customize the code to find user via other attributes, such as SSN or Federation ID
	}
	throw new Auth.LoginDiscoveryException('Invalid Identifier');
}

private boolean isValidEmail(String identifier) {
	String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$';
	// source: http://www.regular-expressions.info/email.html 
	Pattern EmailPattern = Pattern.compile(emailRegex);
	Matcher EmailMatcher = EmailPattern.matcher(identifier);
	if (EmailMatcher.matches()) { return true; }
	else { return false; }
}

private String getFormattedSms(String identifier) {
	// Accept SMS input formats with 1 or 2 digits country code, 3 digits area code and 7 digits number
	// You can customize the SMS regex to allow different formats
	String smsRegex = '^(\\+?\\d{1,2}?[\\s-])?(\\(?\\d{3}\\)?[\\s-]?\\d{3}[\\s-]?\\d{4})$';
	Pattern smsPattern = Pattern.compile(smsRegex);
	Matcher smsMatcher = SmsPattern.matcher(identifier);
	if (smsMatcher.matches()) {
		try {
			// Format user input into the verified SMS format '+xx xxxxxxxxxx' before DB lookup
			// Append US country code +1 by default if no country code is provided
			String countryCode = smsMatcher.group(1) == null ? '+1' : smsMatcher.group(1);
			return System.UserManagement.formatPhoneNumber(countryCode, smsMatcher.group(2));
		} catch(System.InvalidParameterValueException e) {
			return null;
		}
	} else { return null; }
}

private PageReference getSsoRedirect(User user, String startUrl, Map<String, String> requestAttributes) {
	// You can look up if the user should log in with SAML or an Auth Provider and return the URL to initialize SSO.
	return null;
}

private PageReference discoveryResult(User user, Auth.VerificationMethod method, String startUrl, Map<String, String> requestAttributes) {
	//Only external users with an External Identity or community license can login using Site.passwordlessLogin
	//Use getSsoRedirect to enable internal user login for a community
	PageReference ssoRedirect = getSsoRedirect(user, startUrl, requestAttributes);
	if (ssoRedirect != null) {
		return ssoRedirect;
	} else {
		if (method != null) {
			List<Auth.VerificationMethod> methods = new List<Auth.VerificationMethod>();
			methods.add(method);
			PageReference pwdlessRedirect = Site.passwordlessLogin(user.Id, methods, startUrl);
			if (pwdlessRedirect != null) {
				return pwdlessRedirect;
			} else {
				throw new Auth.LoginDiscoveryException('No Passwordless Login redirect URL returned for verification method: ' + method);
			}
		} else {
			throw new Auth.LoginDiscoveryException('No method found');
		}
	}
}
}