import './Navbar.scss';
import React from 'react';

const menu = [
  ['About Us', '#aboutus'],
  ['For You', '#foryou'],
  ['Services', '#services'],
  ['Blog', '#blog'],
  ['Vlog', '#vlog'],
  ['Contact', '#contact'],
];

const Navbar = () => {
  return (
    <div className="navbar">
      {menu.map((item, index) => (
        <a key={index} href={item[1]}>
          {item[0]}
        </a>
      ))}
    </div>
  );
};

export default Navbar;
