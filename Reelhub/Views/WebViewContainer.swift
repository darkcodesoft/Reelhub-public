//
//  WebViewStore.swift
//  Reelhub
//
//  Created by Teddy Moussignac on 3/29/23.
//

import SwiftUI
import WebKit

class WebViewStore: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var canGoBack: Bool = false
    @Published var shouldGoBack: Bool = false
    @Published var title: String = ""
    
    var url = ""
    
    init(url: String? = nil) {
        if let url = url {
            self.url = url
        }
    }
}

struct WebViewContainer: UIViewRepresentable {
    @ObservedObject var webViewStore: WebViewStore
    
    func makeCoordinator() -> WebViewContainer.Coordinator {
        Coordinator(self, webViewStore)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.webViewStore.url) else {
            return WKWebView()
        }
        
        let request = URLRequest(url: url)
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        webView.load(request)
        
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if webViewStore.shouldGoBack {
            uiView.goBack()
            webViewStore.shouldGoBack = false
        }
    }
}

extension WebViewContainer {
    class Coordinator: NSObject, WKNavigationDelegate {
        @ObservedObject private var webViewStore: WebViewStore
        private let parent: WebViewContainer
        
        init(_ parent: WebViewContainer, _ webViewStore: WebViewStore) {
            self.parent = parent
            self.webViewStore = webViewStore
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            webViewStore.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            webViewStore.isLoading = false
            webViewStore.title = webViewStore.title.count > 0  ? webViewStore.title : (webView.title ?? "")
            webViewStore.canGoBack = webView.canGoBack
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            webViewStore.isLoading = false
        }
    }
}

struct WebView: View {
    
    @EnvironmentObject var webViewStore: WebViewStore
    
    var body: some View {
        ZStack {
            WebViewContainer(webViewStore: webViewStore)
            if webViewStore.isLoading {
                ProgressView()
                    .frame(height: 30)
            }
        }
        .navigationBarTitle("")
        .navigationBarTitleDisplayMode(.inline)
        // .navigationBarTitle(Text(webViewStore.title), displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
                webViewStore.shouldGoBack.toggle()
            }, label: {
                if webViewStore.canGoBack {
                    Image(systemName: "arrow.left")
                        .frame(width: 44, height: 44, alignment: .center)
                        .foregroundColor(.black)
                } else {
                    EmptyView()
                        .frame(width: 0, height: 0, alignment: .center)
                }
            })
        )
    }
}
