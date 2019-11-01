/*
 * Copyright (c) 2011-2018, The MathWorks, Inc.<consulting@mathworks.com>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * * Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * * Redistributions in binary form must reproduce the above copyright notice,
 *   this list of conditions and the following disclaimer in the documentation
 *   and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
 * LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 * CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 * SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 * INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 * CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
 * POSSIBILITY OF SUCH DAMAGE.
 */

package com.mathworks.consulting.widgets.tree;

import javax.swing.Icon;
import javax.swing.tree.DefaultMutableTreeNode;
import javax.swing.tree.TreePath;

public class TreeNode extends DefaultMutableTreeNode {

    Icon Icon;
    String TooltipString;
    boolean CheckBoxEnabled = true;
    boolean CheckBoxVisible = true;

    
    /* CONSTRUCTORS */
    
    public TreeNode() {
        super();
        Icon = null;
        TooltipString = null;
    }

    public TreeNode(Object userObject) {
        super(userObject);
        Icon = null;
        TooltipString = null;
    }

    public TreeNode(Object userObject, boolean allowsChildren) {
        super(userObject,allowsChildren);
        Icon = null;
        TooltipString = null;
    }
    
    /* METHODS */
    
    public TreePath getTreePath() {
        return new TreePath(this.getPath());
    }
    
    public Icon getIcon() {
        return this.Icon;
    }

    public void setIcon(Icon icon) {
        this.Icon = icon;
    }

    public String getTooltipString() {
        return this.TooltipString;
    }

    public void setTooltipString(String value) {
        this.TooltipString = value;
    }
    
    public boolean getCheckBoxEnabled() {
        return this.CheckBoxEnabled;
    }
    
    public void setCheckBoxEnabled(boolean value) {
        this.CheckBoxEnabled = value;
    }
    
    public boolean getCheckBoxVisible() {
        return this.CheckBoxVisible;
    }
    
    public void setCheckBoxVisible(boolean value) {
        this.CheckBoxVisible = value;
    }

}
