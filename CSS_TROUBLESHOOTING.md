# CSS Troubleshooting Guide

## Common Issues and Solutions

### Issue 1: CSS Not Loading

**Symptoms:**
- Page appears unstyled
- Browser shows 404 error for CSS file in console

**Solutions:**

1. **Check the CSS file path**
   ```html
   <!-- Correct path -->
   <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
   
   <!-- NOT these -->
   <link rel="stylesheet" href="/css/style.css">
   <link rel="stylesheet" href="css/style.css">
   ```

2. **Verify CSS file location**
   - CSS file must be at: `src/main/webapp/css/style.css`
   - NOT in `WEB-INF` folder (files there are not publicly accessible)

3. **Clear browser cache**
   - Press `Ctrl + Shift + Delete` (Windows)
   - Or `Ctrl + F5` to hard refresh

4. **Check server deployment**
   - Clean and rebuild project
   - In Eclipse: Right-click project → Clean... → Build Project
   - Restart Tomcat server

### Issue 2: Styles Applied Incorrectly

**Symptoms:**
- Some elements look wrong
- Buttons or forms don't match expected design

**Solutions:**

1. **Check class names for typos**
   ```html
   <!-- Correct -->
   <button class="btn btn-primary">Click</button>
   
   <!-- Incorrect -->
   <button class="btn btn-primery">Click</button>
   ```

2. **Ensure proper HTML structure**
   ```html
   <!-- Correct -->
   <div class="form-group">
       <label class="form-label">Name</label>
       <input type="text" class="form-control">
   </div>
   
   <!-- Incorrect - missing wrapper -->
   <label class="form-label">Name</label>
   <input type="text" class="form-control">
   ```

3. **Use browser DevTools**
   - Press `F12` to open DevTools
   - Click on element to inspect
   - Check which CSS rules are applied
   - Look for crossed-out styles (overridden)

### Issue 3: Responsive Layout Broken

**Symptoms:**
- Layout looks bad on mobile devices
- Elements overlap or overflow

**Solutions:**

1. **Add viewport meta tag**
   ```html
   <head>
       <meta name="viewport" content="width=device-width, initial-scale=1.0">
       <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
   </head>
   ```

2. **Use responsive containers**
   ```html
   <!-- Use container class -->
   <div class="container">
       <!-- Content here -->
   </div>
   ```

3. **Test on different screen sizes**
   - Open DevTools (F12)
   - Click device toolbar icon (Ctrl + Shift + M)
   - Test different device sizes

### Issue 4: Buttons Not Clickable

**Symptoms:**
- Buttons appear but don't respond to clicks
- Cursor doesn't change to pointer

**Solutions:**

1. **Check for overlapping elements**
   ```css
   /* Check z-index values in DevTools */
   ```

2. **Ensure proper button structure**
   ```html
   <!-- For links styled as buttons -->
   <a href="#" class="btn btn-primary">Click Me</a>
   
   <!-- For actual buttons -->
   <button type="button" class="btn btn-primary">Click Me</button>
   ```

3. **Verify no pointer-events: none**
   - Check in DevTools if element has `pointer-events: none`

### Issue 5: Colors Not Matching Design

**Symptoms:**
- Colors appear different than expected
- Buttons have wrong colors

**Solutions:**

1. **Use correct button classes**
   ```html
   <button class="btn btn-primary">Primary (Blue)</button>
   <button class="btn btn-success">Success (Green)</button>
   <button class="btn btn-danger">Danger (Red)</button>
   <button class="btn btn-warning">Warning (Orange)</button>
   ```

2. **Check for inline styles overriding**
   ```html
   <!-- Remove inline styles -->
   <button class="btn btn-primary" style="background: red;">Bad</button>
   
   <!-- Use CSS classes instead -->
   <button class="btn btn-danger">Good</button>
   ```

3. **Verify no conflicting CSS**
   - Check if other CSS files are loaded
   - Remove old style tags from JSP pages

### Issue 6: Tables Look Broken

**Symptoms:**
- Table columns misaligned
- Table overflows on mobile

**Solutions:**

1. **Wrap table in responsive container**
   ```html
   <div class="table-responsive">
       <table class="table">
           <!-- table content -->
       </table>
   </div>
   ```

2. **Use proper table structure**
   ```html
   <table class="table">
       <thead>
           <tr>
               <th>Header 1</th>
               <th>Header 2</th>
           </tr>
       </thead>
       <tbody>
           <tr>
               <td>Data 1</td>
               <td>Data 2</td>
           </tr>
       </tbody>
   </table>
   ```

3. **For action buttons in tables**
   ```html
   <td class="action-buttons">
       <a href="#" class="btn btn-sm btn-primary">Edit</a>
       <a href="#" class="btn btn-sm btn-danger">Delete</a>
   </td>
   ```

### Issue 7: Forms Look Misaligned

**Symptoms:**
- Input fields different sizes
- Labels not aligned properly

**Solutions:**

1. **Use form-group wrapper**
   ```html
   <div class="form-group">
       <label class="form-label" for="email">Email</label>
       <input type="email" id="email" class="form-control">
   </div>
   ```

2. **Ensure form-control on all inputs**
   ```html
   <input type="text" class="form-control">
   <textarea class="form-control"></textarea>
   <select class="form-control">
       <option>Option 1</option>
   </select>
   ```

3. **For inline forms**
   ```html
   <div class="d-flex gap-md">
       <input type="text" class="form-control">
       <button class="btn btn-primary">Submit</button>
   </div>
   ```

### Issue 8: Navigation Menu Broken

**Symptoms:**
- Menu items stacked incorrectly
- Navigation doesn't look right

**Solutions:**

1. **Use complete navigation structure**
   ```html
   <header class="header">
       <div class="container">
           <nav class="navbar">
               <a href="#" class="navbar-brand">Brand</a>
               <ul class="navbar-nav">
                   <li class="nav-item">
                       <a href="#" class="nav-link">Link</a>
                   </li>
               </ul>
           </nav>
       </div>
   </header>
   ```

2. **Mark active page**
   ```html
   <a href="#" class="nav-link active">Current Page</a>
   ```

### Issue 9: Cards Not Displaying Correctly

**Symptoms:**
- Cards missing borders or shadows
- Card content overflowing

**Solutions:**

1. **Use complete card structure**
   ```html
   <div class="card">
       <div class="card-header">Header (optional)</div>
       <div class="card-body">
           <h5 class="card-title">Title</h5>
           <p class="card-text">Content</p>
       </div>
       <div class="card-footer">Footer (optional)</div>
   </div>
   ```

2. **Don't nest cards incorrectly**
   ```html
   <!-- Incorrect -->
   <div class="card">
       <div class="card">...</div>
   </div>
   
   <!-- Correct - side by side -->
   <div class="d-flex gap-md">
       <div class="card">...</div>
       <div class="card">...</div>
   </div>
   ```

### Issue 10: Spacing Issues

**Symptoms:**
- Elements too close together
- Inconsistent spacing

**Solutions:**

1. **Use utility spacing classes**
   ```html
   <div class="mb-3">Margin bottom large</div>
   <div class="mt-2">Margin top medium</div>
   <div class="p-2">Padding medium</div>
   ```

2. **Use gap for flex/grid layouts**
   ```html
   <div class="d-flex gap-md">
       <button class="btn btn-primary">Button 1</button>
       <button class="btn btn-secondary">Button 2</button>
   </div>
   ```

3. **Use container for page margins**
   ```html
   <div class="container">
       <!-- Proper left/right margins automatically applied -->
   </div>
   ```

## Debugging Workflow

### Step 1: Open Browser DevTools
- Press `F12` or right-click → "Inspect"

### Step 2: Check Console for Errors
- Look for 404 errors (file not found)
- Look for CSS parsing errors

### Step 3: Inspect Element
- Click inspector tool
- Click on problem element
- Check "Styles" panel on right

### Step 4: Verify CSS Rules
- Are correct classes applied?
- Are styles being overridden?
- Are there conflicting rules?

### Step 5: Test Changes
- Edit CSS in DevTools to test fixes
- Once working, apply to actual CSS file

## Browser Compatibility

The CSS system supports:
- ✅ Chrome 90+
- ✅ Firefox 88+
- ✅ Edge 90+
- ✅ Safari 14+
- ⚠️ IE 11 (limited support, some features may not work)

## Performance Tips

1. **CSS file is cached** - Changes may require hard refresh (Ctrl + F5)
2. **Minimize inline styles** - Use CSS classes instead
3. **Don't load multiple CSS frameworks** - Use only this CSS file
4. **Optimize images** - Use appropriate formats and sizes

## Getting Help

### Check These First:
1. ✅ CSS file path is correct
2. ✅ Class names are spelled correctly
3. ✅ HTML structure matches examples
4. ✅ Browser cache is cleared
5. ✅ Server is restarted after changes

### Browser DevTools Checklist:
- [ ] No 404 errors for CSS file
- [ ] CSS rules showing in Elements panel
- [ ] No JavaScript errors blocking page load
- [ ] Element has expected classes applied
- [ ] No conflicting CSS rules

### Eclipse/Tomcat Checklist:
- [ ] CSS file in correct location: `src/main/webapp/css/style.css`
- [ ] Project built successfully (no build errors)
- [ ] Tomcat server started without errors
- [ ] Application deployed to server
- [ ] No file permission issues

## Quick Fixes

### Fix 1: Hard Refresh
```
Windows: Ctrl + F5
Mac: Cmd + Shift + R
```

### Fix 2: Clear Project and Rebuild
```
Eclipse → Project → Clean → Select Project → Clean
Eclipse → Project → Build Project
```

### Fix 3: Restart Tomcat
```
Servers tab → Right-click Tomcat → Restart
```

### Fix 4: Check Tomcat Console
```
Look for deployment errors
Check for file not found errors
```

### Fix 5: Verify Deployment
```
Right-click project → Properties → Deployment Assembly
Ensure "src/main/webapp" maps to "/"
```

## Still Having Issues?

1. **Create a minimal test page** to isolate the problem
2. **Compare your code** with examples in CSS_STYLING_GUIDE.md
3. **Check browser console** for specific error messages
4. **Test in different browser** to rule out browser-specific issues
5. **Verify file encoding** is UTF-8

## Common Mistakes to Avoid

❌ **Don't do this:**
- Putting CSS in WEB-INF folder
- Using wrong path: `/css/style.css` instead of `${pageContext.request.contextPath}/css/style.css`
- Mixing inline styles with CSS classes
- Creating custom CSS files that conflict
- Forgetting to add viewport meta tag
- Not using container class for layout
- Nesting form-groups incorrectly
- Forgetting table-responsive wrapper

✅ **Do this instead:**
- Follow the examples in CSS_STYLING_GUIDE.md
- Use provided utility classes
- Test on multiple screen sizes
- Keep HTML structure clean and semantic
- Use browser DevTools for debugging
- Clear cache when testing changes