#[cfg(windows)]
mod windows;
#[cfg(windows)]
pub use windows::*;

#[cfg(unix)]
mod linux;
#[cfg(unix)]
pub use linux::*;
