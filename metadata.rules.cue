#Spec: {
	app:  #NonEmptyString
	base: bool
	channels: [...#Channels]
}

#Channels: {
	name: #NonEmptyString
	platforms: [...#AcceptedPlatforms]
	stable: bool
}

#NonEmptyString:           string & !=""
#AcceptedPlatforms:        "linux/amd64" | "linux/arm64"
