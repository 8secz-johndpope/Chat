//
// This is a generated file, do not edit!
// Generated by R.swift, see https://github.com/mac-cain13/R.swift
//

import Foundation
import Rswift
import UIKit

/// This `R` struct is generated and contains references to static resources.
struct R: Rswift.Validatable {
  fileprivate static let applicationLocale = hostingBundle.preferredLocalizations.first.flatMap(Locale.init) ?? Locale.current
  fileprivate static let hostingBundle = Bundle(for: R.Class.self)
  
  static func validate() throws {
    try intern.validate()
  }
  
  /// This `R.file` struct is generated, and contains static references to 1 files.
  struct file {
    /// Resource file `GoogleService-Info.plist`.
    static let googleServiceInfoPlist = Rswift.FileResource(bundle: R.hostingBundle, name: "GoogleService-Info", pathExtension: "plist")
    
    /// `bundle.url(forResource: "GoogleService-Info", withExtension: "plist")`
    static func googleServiceInfoPlist(_: Void = ()) -> Foundation.URL? {
      let fileResource = R.file.googleServiceInfoPlist
      return fileResource.bundle.url(forResource: fileResource)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.image` struct is generated, and contains static references to 6 images.
  struct image {
    /// Image `contacts`.
    static let contacts = Rswift.ImageResource(bundle: R.hostingBundle, name: "contacts")
    /// Image `error`.
    static let error = Rswift.ImageResource(bundle: R.hostingBundle, name: "error")
    /// Image `messages`.
    static let messages = Rswift.ImageResource(bundle: R.hostingBundle, name: "messages")
    /// Image `profile`.
    static let profile = Rswift.ImageResource(bundle: R.hostingBundle, name: "profile")
    /// Image `settings`.
    static let settings = Rswift.ImageResource(bundle: R.hostingBundle, name: "settings")
    /// Image `success`.
    static let success = Rswift.ImageResource(bundle: R.hostingBundle, name: "success")
    
    /// `UIImage(named: "contacts", bundle: ..., traitCollection: ...)`
    static func contacts(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.contacts, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "error", bundle: ..., traitCollection: ...)`
    static func error(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.error, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "messages", bundle: ..., traitCollection: ...)`
    static func messages(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.messages, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "profile", bundle: ..., traitCollection: ...)`
    static func profile(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.profile, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "settings", bundle: ..., traitCollection: ...)`
    static func settings(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.settings, compatibleWith: traitCollection)
    }
    
    /// `UIImage(named: "success", bundle: ..., traitCollection: ...)`
    static func success(compatibleWith traitCollection: UIKit.UITraitCollection? = nil) -> UIKit.UIImage? {
      return UIKit.UIImage(resource: R.image.success, compatibleWith: traitCollection)
    }
    
    fileprivate init() {}
  }
  
  /// This `R.reuseIdentifier` struct is generated, and contains static references to 2 reuse identifiers.
  struct reuseIdentifier {
    /// Reuse identifier `MessageCell`.
    static let messageCell: Rswift.ReuseIdentifier<UIKit.UITableViewCell> = Rswift.ReuseIdentifier(identifier: "MessageCell")
    /// Reuse identifier `contactCell`.
    static let contactCell: Rswift.ReuseIdentifier<UIKit.UITableViewCell> = Rswift.ReuseIdentifier(identifier: "contactCell")
    
    fileprivate init() {}
  }
  
  /// This `R.storyboard` struct is generated, and contains static references to 3 storyboards.
  struct storyboard {
    /// Storyboard `Auth`.
    static let auth = _R.storyboard.auth()
    /// Storyboard `LaunchScreen`.
    static let launchScreen = _R.storyboard.launchScreen()
    /// Storyboard `Main`.
    static let main = _R.storyboard.main()
    
    /// `UIStoryboard(name: "Auth", bundle: ...)`
    static func auth(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.auth)
    }
    
    /// `UIStoryboard(name: "LaunchScreen", bundle: ...)`
    static func launchScreen(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.launchScreen)
    }
    
    /// `UIStoryboard(name: "Main", bundle: ...)`
    static func main(_: Void = ()) -> UIKit.UIStoryboard {
      return UIKit.UIStoryboard(resource: R.storyboard.main)
    }
    
    fileprivate init() {}
  }
  
  fileprivate struct intern: Rswift.Validatable {
    fileprivate static func validate() throws {
      try _R.validate()
    }
    
    fileprivate init() {}
  }
  
  fileprivate class Class {}
  
  fileprivate init() {}
}

struct _R: Rswift.Validatable {
  static func validate() throws {
    try storyboard.validate()
  }
  
  struct storyboard: Rswift.Validatable {
    static func validate() throws {
      try auth.validate()
      try launchScreen.validate()
      try main.validate()
    }
    
    struct auth: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = HomeViewController
      
      let bundle = R.hostingBundle
      let homeViewController = StoryboardViewControllerResource<HomeViewController>(identifier: "HomeViewController")
      let name = "Auth"
      let resetPasswordViewController = StoryboardViewControllerResource<ResetPasswordViewController>(identifier: "ResetPasswordViewController")
      let signInViewController = StoryboardViewControllerResource<SignInViewController>(identifier: "SignInViewController")
      let signUpViewController = StoryboardViewControllerResource<SignUpViewController>(identifier: "SignUpViewController")
      let verificationViewController = StoryboardViewControllerResource<VerificationViewController>(identifier: "VerificationViewController")
      
      func homeViewController(_: Void = ()) -> HomeViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: homeViewController)
      }
      
      func resetPasswordViewController(_: Void = ()) -> ResetPasswordViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: resetPasswordViewController)
      }
      
      func signInViewController(_: Void = ()) -> SignInViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: signInViewController)
      }
      
      func signUpViewController(_: Void = ()) -> SignUpViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: signUpViewController)
      }
      
      func verificationViewController(_: Void = ()) -> VerificationViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: verificationViewController)
      }
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.auth().homeViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'homeViewController' could not be loaded from storyboard 'Auth' as 'HomeViewController'.") }
        if _R.storyboard.auth().resetPasswordViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'resetPasswordViewController' could not be loaded from storyboard 'Auth' as 'ResetPasswordViewController'.") }
        if _R.storyboard.auth().signInViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'signInViewController' could not be loaded from storyboard 'Auth' as 'SignInViewController'.") }
        if _R.storyboard.auth().signUpViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'signUpViewController' could not be loaded from storyboard 'Auth' as 'SignUpViewController'.") }
        if _R.storyboard.auth().verificationViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'verificationViewController' could not be loaded from storyboard 'Auth' as 'VerificationViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    struct launchScreen: Rswift.StoryboardResourceWithInitialControllerType, Rswift.Validatable {
      typealias InitialController = UIKit.UIViewController
      
      let bundle = R.hostingBundle
      let name = "LaunchScreen"
      
      static func validate() throws {
        if #available(iOS 11.0, *) {
        }
      }
      
      fileprivate init() {}
    }
    
    struct main: Rswift.StoryboardResourceType, Rswift.Validatable {
      let bundle = R.hostingBundle
      let contactsTableViewController = StoryboardViewControllerResource<ContactsTableViewController>(identifier: "ContactsTableViewController")
      let mainTabBarController = StoryboardViewControllerResource<MainTabBarController>(identifier: "MainTabBarController")
      let messagesTableViewController = StoryboardViewControllerResource<MessagesTableViewController>(identifier: "MessagesTableViewController")
      let name = "Main"
      let searchContactsViewController = StoryboardViewControllerResource<SearchContactsViewController>(identifier: "SearchContactsViewController")
      let settingsViewController = StoryboardViewControllerResource<SettingsViewController>(identifier: "SettingsViewController")
      
      func contactsTableViewController(_: Void = ()) -> ContactsTableViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: contactsTableViewController)
      }
      
      func mainTabBarController(_: Void = ()) -> MainTabBarController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: mainTabBarController)
      }
      
      func messagesTableViewController(_: Void = ()) -> MessagesTableViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: messagesTableViewController)
      }
      
      func searchContactsViewController(_: Void = ()) -> SearchContactsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: searchContactsViewController)
      }
      
      func settingsViewController(_: Void = ()) -> SettingsViewController? {
        return UIKit.UIStoryboard(resource: self).instantiateViewController(withResource: settingsViewController)
      }
      
      static func validate() throws {
        if UIKit.UIImage(named: "contacts", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'contacts' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "messages", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'messages' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "profile", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'profile' is used in storyboard 'Main', but couldn't be loaded.") }
        if UIKit.UIImage(named: "settings", in: R.hostingBundle, compatibleWith: nil) == nil { throw Rswift.ValidationError(description: "[R.swift] Image named 'settings' is used in storyboard 'Main', but couldn't be loaded.") }
        if #available(iOS 11.0, *) {
        }
        if _R.storyboard.main().contactsTableViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'contactsTableViewController' could not be loaded from storyboard 'Main' as 'ContactsTableViewController'.") }
        if _R.storyboard.main().mainTabBarController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'mainTabBarController' could not be loaded from storyboard 'Main' as 'MainTabBarController'.") }
        if _R.storyboard.main().messagesTableViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'messagesTableViewController' could not be loaded from storyboard 'Main' as 'MessagesTableViewController'.") }
        if _R.storyboard.main().searchContactsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'searchContactsViewController' could not be loaded from storyboard 'Main' as 'SearchContactsViewController'.") }
        if _R.storyboard.main().settingsViewController() == nil { throw Rswift.ValidationError(description:"[R.swift] ViewController with identifier 'settingsViewController' could not be loaded from storyboard 'Main' as 'SettingsViewController'.") }
      }
      
      fileprivate init() {}
    }
    
    fileprivate init() {}
  }
  
  fileprivate init() {}
}
