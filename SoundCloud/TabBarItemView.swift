//
//  TabBarItemView.swift
//  SoundCloud
//
//  Created by Jaufré on 11/02/2025.
//

import SwiftUI

struct TabBarItemView: View {
    let tab: TabItem
    let isSelected: Bool
    let onSelect: () -> Void
    let onClose: () -> Void
    
    @ObservedObject private var container: WebViewContainer
    
    @State private var isHovering = false
    @State private var isHoveringClose = false
    
    init(tab: TabItem, isSelected: Bool, onSelect: @escaping () -> Void, onClose: @escaping () -> Void) {
        self.tab = tab
        self.isSelected = isSelected
        self.onSelect = onSelect
        self.onClose = onClose
        self._container = ObservedObject(wrappedValue: tab.container)
    }
    
    @Environment(\.colorScheme) var colorScheme

    var backgroundColor: Color {
        if isSelected {
            return colorScheme == .dark ? Color(NSColor.darkGray) : Color(NSColor.windowBackgroundColor)
        } else {
            return colorScheme == .dark
                ? Color(NSColor.gray).opacity(isHovering ? 0.3 : 0.2)
                : Color(NSColor.lightGray).opacity(isHovering ? 0.5 : 0.4)
        }
    }

    
    var body: some View {
        HStack(spacing: 4) {
            // Left area: close button.
            Group {
                if isHovering {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 10, height: 10)
                            .padding(4)
                            .background(
                                isHoveringClose
                                ? RoundedRectangle(cornerRadius: 0)
                                    .fill(Color.primary.opacity(0.2))
                                : RoundedRectangle(cornerRadius: 0)
                                    .fill(Color.clear)
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onHover { hover in
                        withAnimation(.easeInOut(duration: 0.2)) {
                            isHoveringClose = hover
                        }
                    }
                } else {
                    Color.clear.frame(width: 24, height: 24)
                }
            }
            .frame(width: 24, height: 24, alignment: .center)
            
            let effectiveTitle: String = {
                if let title = container.currentTitle?.trimmingCharacters(in: .whitespacesAndNewlines), !title.isEmpty {
                    return title
                }
                return container.currentURL?.shortDisplayName ?? tab.url.shortDisplayName
            }()
            
            Text(effectiveTitle)
                .lineLimit(1)
                .font(.callout)
                .foregroundColor(isSelected ? .primary : .secondary)
                .frame(maxWidth: .infinity, alignment: .center)
            
            Color.clear.frame(width: 24, height: 24)
        }
        .padding(.horizontal, 4)
        .frame(height: 30)
        .background(backgroundColor)
        // Remove rounded corners.
        //.cornerRadius(4)
        // Add a subtle shadow only on the active tab.
        .shadow(color: isSelected ? Color.black.opacity(0.1) : Color.clear, radius: 2, x: 0, y: 1)
        .contentShape(Rectangle())
        .onTapGesture(perform: onSelect)
        .onHover { hover in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovering = hover
            }
        }
    }
}
