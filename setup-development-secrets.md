# Development Build Setup Instructions

## What you need to do in Apple Developer Portal:

1. **Create Development Certificate:**
   - Go to Apple Developer Portal > Certificates, Identifiers & Profiles
   - Create a new "Apple Development" certificate
   - Download the certificate and export as .p12 with a password

2. **Create Development Provisioning Profile:**
   - Go to Profiles section
   - Create new "iOS App Development" profile
   - Select your app ID (com.bradleylund.Broke)
   - Select your development certificate
   - **Important:** Add your iPhone's UDID to the profile
   - Download the .mobileprovision file

## GitHub Secrets to Add:

Add these secrets to your GitHub repository (Settings > Secrets and variables > Actions):

1. `DEV_BUILD_CERTIFICATE_BASE64` - Base64 encoded .p12 development certificate
2. `DEV_P12_PASSWORD` - Password for the .p12 certificate
3. `DEV_PROVISIONING_PROFILE_BASE64` - Base64 encoded .mobileprovision file

## How to get Base64 values:

### On Windows (PowerShell):
```powershell
# For certificate
[Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\your\certificate.p12"))

# For provisioning profile
[Convert]::ToBase64String([IO.File]::ReadAllBytes("path\to\your\profile.mobileprovision"))
```

### On Mac/Linux:
```bash
# For certificate
base64 -i certificate.p12

# For provisioning profile
base64 -i profile.mobileprovision
```

## Getting your iPhone UDID:

1. Connect iPhone to computer
2. Open iTunes/Finder
3. Click on device, then click on serial number to reveal UDID
4. Copy the UDID and add it to your development provisioning profile

## Installation Tools for Windows:

- **3uTools** (recommended) - Free iOS management tool
- **iTunes** - Can install IPAs but interface is clunky
- **iMazing** - Paid but very user-friendly

## Triggering the Build:

1. **Manual:** Go to GitHub Actions tab, select "Build Development IPA", click "Run workflow"
2. **Automatic:** Push to a "development" branch (you can change this in the workflow)

The IPA will be available as:
- GitHub Actions artifact (for 30 days)
- GitHub release (permanent, tagged as dev-build-X)