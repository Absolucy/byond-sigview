pub mod sigscan;

use std::cell::RefCell;

use self::sigscan::Scanner;
use meowtonin::byond_fn;

fn from_signature(s: String) -> Vec<Option<u8>> {
	s.trim()
		.split(' ')
		.map(|byte| {
			let byte = byte.trim();
			match byte.len() {
				2 => {
					if byte == "??" {
						None
					} else {
						hex::decode(byte).map(|decoded_byte| decoded_byte[0]).ok()
					}
				}
				_ => None,
			}
		})
		.collect()
}

#[cfg(windows)]
pub const BYONDCORE: &str = "byondcore.dll";
#[cfg(unix)]
pub const BYONDCORE: &str = "libbyond.so";

thread_local! {
	static SCANNER: RefCell<Scanner> = RefCell::new(sigscan::Scanner::for_module(BYONDCORE).expect("failed to get scanner"));
}

#[byond_fn]
pub fn check_for_sig(signature: String) -> bool {
	SCANNER.with_borrow(|scanner| {
		let signature = from_signature(signature);
		scanner.find(&signature).is_some()
	})
}
